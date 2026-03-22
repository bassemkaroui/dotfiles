#!/usr/bin/env bash
set -euo pipefail

# ─── Sanitize private dotfiles and sync to public mirror repo ────────────────
# Reads .sanitize.yml for replacement rules, excluded files, and leak patterns.
# Set DRYRUN=1 to skip push and inspect output locally.

REPO_ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)"
CONFIG="$REPO_ROOT/.sanitize.yml"
PUBLIC_REPO="${PUBLIC_REPO:-bassemkaroui/dotfiles}"
DRYRUN="${DRYRUN:-0}"

# ─── Helpers ─────────────────────────────────────────────────────────────────

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
ok()    { printf '\033[1;32m[ OK ]\033[0m  %s\n' "$*"; }
fail()  { printf '\033[1;31m[FAIL]\033[0m  %s\n' "$*"; exit 1; }

require_cmd() {
    command -v "$1" &>/dev/null || fail "'$1' is required but not found"
}

escape_sed() {
    printf '%s' "$1" | sed 's/[.[\*^$/\\&]/\\&/g'
}

# ─── Prerequisites ───────────────────────────────────────────────────────────

require_cmd yq
require_cmd git
require_cmd sed
require_cmd file

[[ -f "$CONFIG" ]] || fail "Config not found: $CONFIG"

# ─── Step 1: Export tracked files ────────────────────────────────────────────

WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

info "Exporting tracked files to $WORK_DIR"
git -C "$REPO_ROOT" archive HEAD | tar -x -C "$WORK_DIR"

# ─── Step 2: Export submodule content ────────────────────────────────────────

info "Exporting submodule content"
git -C "$REPO_ROOT" submodule foreach --quiet \
    'git archive HEAD | tar -x -C "'"$WORK_DIR"'/$sm_path"' 2>/dev/null || true

# ─── Step 3: Remove excluded files ──────────────────────────────────────────

info "Removing excluded files"
EXCLUDE_COUNT=$(yq '.exclude_files | length' "$CONFIG")
for i in $(seq 0 $((EXCLUDE_COUNT - 1))); do
    pattern=$(yq -r ".exclude_files[$i]" "$CONFIG")
    # Use find with the pattern relative to WORK_DIR
    find "$WORK_DIR" -path "$WORK_DIR/$pattern" -exec rm -rf {} + 2>/dev/null || true
done

# ─── Step 4: Apply text replacements ────────────────────────────────────────

info "Applying sanitization replacements"
REPLACE_COUNT=$(yq '.replacements | length' "$CONFIG")

for i in $(seq 0 $((REPLACE_COUNT - 1))); do
    FIND_RAW=$(yq -r ".replacements[$i].find" "$CONFIG")
    REPLACE_RAW=$(yq -r ".replacements[$i].replace" "$CONFIG")
    FILES_SCOPE=$(yq -r ".replacements[$i].files // \"\"" "$CONFIG")

    FIND_ESCAPED=$(escape_sed "$FIND_RAW")
    REPLACE_ESCAPED=$(escape_sed "$REPLACE_RAW")

    if [[ -n "$FILES_SCOPE" ]]; then
        # Scoped to specific file patterns
        find "$WORK_DIR" -path "$WORK_DIR/$FILES_SCOPE" -type f | while IFS= read -r filepath; do
            if file --mime-encoding "$filepath" | grep -q binary; then continue; fi
            sed -i "s|${FIND_ESCAPED}|${REPLACE_ESCAPED}|g" "$filepath"
        done
    else
        # Apply to all text files
        find "$WORK_DIR" -type f | while IFS= read -r filepath; do
            if file --mime-encoding "$filepath" | grep -q binary; then continue; fi
            sed -i "s|${FIND_ESCAPED}|${REPLACE_ESCAPED}|g" "$filepath"
        done
    fi
done

ok "Replacements applied ($REPLACE_COUNT rules)"

# ─── Step 5: Generate CUSTOMIZE.md ──────────────────────────────────────────

info "Generating CUSTOMIZE.md"

CUSTOMIZE="$WORK_DIR/CUSTOMIZE.md"
cat > "$CUSTOMIZE" << 'HEADER'
# Customization Guide

This repo uses placeholder values for personal information. To use these dotfiles, search and replace the placeholders below with your own values.

| Placeholder | Description | Files |
|-------------|-------------|-------|
HEADER

for i in $(seq 0 $((REPLACE_COUNT - 1))); do
    REPLACE_VAL=$(yq -r ".replacements[$i].replace" "$CONFIG")
    FIND_VAL=$(yq -r ".replacements[$i].find" "$CONFIG")

    # Find which files contain this placeholder
    MATCHED_FILES=$(grep -rIl --include='*' -F "$REPLACE_VAL" "$WORK_DIR" 2>/dev/null \
        | sed "s|^$WORK_DIR/||" \
        | grep -v '^CUSTOMIZE.md$' \
        | sort \
        | head -5 \
        | tr '\n' ',' \
        | sed 's/,$//' \
        | sed 's/,/, /g') || true

    [[ -z "$MATCHED_FILES" ]] && continue

    # Derive a human-readable description from the replacement context
    case "$REPLACE_VAL" in
        "Your Name")                   DESC="Your full name (for git config)" ;;
        "your-email@example.com")      DESC="Your email address" ;;
        "YOUR_GPG_KEY_ID")             DESC="Your GPG signing key fingerprint" ;;
        "/home/your-username")         DESC="Your home directory path" ;;
        "your-username/.dotfiles")     DESC="Your GitHub username (dotfiles repo URL)" ;;
        "your-username/kickstart.nvim") DESC="Your GitHub username (nvim config URL)" ;;
        "your-domain.example.com")     DESC="Your domain / dynamic DNS hostname" ;;
        "your-ddns.example.com")       DESC="Your secondary DDNS hostname" ;;
        "10.0.0.100")                  DESC="Your VPN / private network IP" ;;
        "my-desktop")                  DESC="Your desktop machine hostname" ;;
        "User your-username")          DESC="Your SSH username" ;;
        *"Port"*)                      DESC="Your custom SSH port" ;;
        *)                             DESC="Custom placeholder" ;;
    esac

    printf '| `%s` | %s | %s |\n' "$REPLACE_VAL" "$DESC" "$MATCHED_FILES" >> "$CUSTOMIZE"
done

cat >> "$CUSTOMIZE" << 'FOOTER'

## Quick Search

Find all placeholders at once:

```bash
grep -rn "your-username\|your-email\|your-domain\|YOUR_" .
```
FOOTER

ok "CUSTOMIZE.md generated"

# ─── Step 6: Inject customization notice into README.md ──────────────────────

README="$WORK_DIR/README.md"
if [[ -f "$README" ]]; then
    info "Adding customization section to README.md"
    TMPREADME=$(mktemp)
    {
        head -1 "$README"
        printf '\n## Customization\n\nThis repo uses placeholder values for personal info (name, email, SSH hosts, etc.).\nSee [CUSTOMIZE.md](CUSTOMIZE.md) for a full list of placeholders to replace.\n'
        tail -n +2 "$README"
    } > "$TMPREADME"
    mv "$TMPREADME" "$README"
    ok "README.md updated"
fi

# ─── Step 7: Leak detection ──────────────────────────────────────────────────

info "Running leak detection"
LEAK_COUNT=$(yq '.leak_patterns | length' "$CONFIG")
LEAK_REGEX=""
for i in $(seq 0 $((LEAK_COUNT - 1))); do
    pattern=$(yq -r ".leak_patterns[$i]" "$CONFIG")
    if [[ -n "$LEAK_REGEX" ]]; then
        LEAK_REGEX="${LEAK_REGEX}|${pattern}"
    else
        LEAK_REGEX="$pattern"
    fi
done

if [[ -n "$LEAK_REGEX" ]]; then
    LEAKS=$(grep -rIl -E "$LEAK_REGEX" "$WORK_DIR" 2>/dev/null || true)
    if [[ -n "$LEAKS" ]]; then
        fail "Sensitive data detected in sanitized output:\n$LEAKS"
    fi
fi

ok "No leaks detected"

# ─── Step 8: Push to public repo (or dry-run) ───────────────────────────────

if [[ "$DRYRUN" == "1" ]]; then
    OUTPUT_DIR="/tmp/dotfiles-sanitized"
    rm -rf "$OUTPUT_DIR"
    cp -a "$WORK_DIR" "$OUTPUT_DIR"
    ok "Dry run complete — sanitized files at: $OUTPUT_DIR"
    exit 0
fi

[[ -n "${GITHUB_TOKEN:-}" ]] || fail "GITHUB_TOKEN is required for push (set DRYRUN=1 for local testing)"

PUBLIC_DIR=$(mktemp -d)
info "Cloning public repo"

if git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/${PUBLIC_REPO}.git" "$PUBLIC_DIR" 2>/dev/null; then
    # Remove all existing content except .git
    find "$PUBLIC_DIR" -mindepth 1 -maxdepth 1 -not -name '.git' -exec rm -rf {} +
else
    # First time — init fresh
    rm -rf "$PUBLIC_DIR"
    mkdir -p "$PUBLIC_DIR"
    cd "$PUBLIC_DIR"
    git init
    git remote add origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${PUBLIC_REPO}.git"
fi

# Copy sanitized content
cp -a "$WORK_DIR"/. "$PUBLIC_DIR"/

cd "$PUBLIC_DIR"
git add -A

if git diff --cached --quiet; then
    ok "No changes to sync"
else
    git commit -m "Sync from private repo ($(date -u +%Y-%m-%dT%H:%M:%SZ))"
    git push --force origin main
    ok "Public mirror updated: https://github.com/${PUBLIC_REPO}"
fi
