# Customization Guide

This repo uses placeholder values for personal information. To use these dotfiles, search and replace the placeholders below with your own values.

| Placeholder | Description | Files |
|-------------|-------------|-------|
| `Your Name` | Your full name (for git config) | git/.gitconfig |
| `your-email@example.com` | Your email address | git/.gitconfig |
| `YOUR_GPG_KEY_ID` | Your GPG signing key fingerprint | git/.gitconfig |
| `your-username/.dotfiles` | Your GitHub username (dotfiles repo URL) | README.md, mise/.config/mise/tasks/setup/dotfiles |
| `your-username/kickstart.nvim` | Your GitHub username (nvim config URL) | .gitmodules |
| `your-domain.example.com` | Your domain / dynamic DNS hostname | ssh/laptop/.ssh/config |
| `your-ddns.example.com` | Your secondary DDNS hostname | ssh/desktop/.ssh/config |
| `10.0.0.100` | Your VPN / private network IP | ssh/laptop/.ssh/config |
| `my-desktop` | Your desktop machine hostname | ssh/laptop/.ssh/config |
| `Port 2222` | Your custom SSH port | ssh/laptop/.ssh/config |
| `Port 2223` | Your custom SSH port | ssh/desktop/.ssh/config |
| `Port 22` | Your custom SSH port | ssh/desktop/.ssh/config, ssh/laptop/.ssh/config |
| `Port 22` | Your custom SSH port | ssh/desktop/.ssh/config, ssh/laptop/.ssh/config |
| `User your-username` | Your SSH username | ssh/desktop/.ssh/config, ssh/laptop/.ssh/config |

## Quick Search

Find all placeholders at once:

```bash
grep -rn "your-username\|your-email\|your-domain\|YOUR_" .
```
