# Customization Guide

This repo uses placeholder values for personal information. To use these dotfiles, search and replace the placeholders below with your own values.

| Placeholder | Description | Files |
|-------------|-------------|-------|
| `Your Name` | Your full name (for git config) | git/tag-default/.gitconfig |
| `your-email@example.com` | Your email address | git/tag-default/.gitconfig |
| `YOUR_GPG_KEY_ID` | Your GPG signing key fingerprint | git/tag-default/.gitconfig |
| `your-username/.dotfiles` | Your GitHub username (dotfiles repo URL) | README.md, mise/tag-default/.config/mise/tasks/setup/dotfiles |
| `your-username/kickstart.nvim` | Your GitHub username (nvim config URL) | .gitmodules |
| `your-ddns.example.com` | Your secondary DDNS hostname | ssh/tag-desktop/.ssh/config |
| `Port 2223` | Your custom SSH port | ssh/tag-desktop/.ssh/config |
| `Port 22` | Your custom SSH port | ssh/tag-desktop/.ssh/config |
| `Port 22` | Your custom SSH port | ssh/tag-desktop/.ssh/config |
| `User your-username` | Your SSH username | ssh/tag-desktop/.ssh/config |

## Quick Search

Find all placeholders at once:

```bash
grep -rn "your-username\|your-email\|your-domain\|YOUR_" .
```
