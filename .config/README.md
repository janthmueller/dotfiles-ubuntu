# 📦 dotfiles-ubuntu

Manage personal Ubuntu dotfiles cleanly with a **bare Git repository**.

---

# ❓ Why this setup?

This method uses a **bare Git repository** to track your dotfiles **directly in your `$HOME` directory**.  
It avoids messy symlinks, keeps your home clean, and gives you full Git version control over your configs.  
You can easily push to GitHub and clone your setup on any new machine.

---

# 📂 Part 1: Setting up and pushing dotfiles (first time)

## 1. Authenticate GitHub CLI

```bash
gh auth login
# Choose GitHub.com -> SSH -> Authenticate
```

## 2. Create GitHub repository

```bash
gh repo create janthmueller/dotfiles-ubuntu --public --confirm
# or --private if you want private
```

## 3. Initialize a bare repository

```bash
git init --bare $HOME/.dotfiles
```

## 4. Set Git alias

```bash
echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> ~/.bashrc
source ~/.bashrc
```

## 5. Hide untracked files

```bash
dotfiles config --local status.showUntrackedFiles no
```

## 6. Add remote repository

```bash
dotfiles remote add origin git@github.com:janthmueller/dotfiles-ubuntu.git
```

## 7. Add and commit your dotfiles

```bash
dotfiles add .tmux.conf
dotfiles add .config/alacritty/alacritty.toml
# Add more files as needed

dotfiles commit -m "Initial commit"
```

## 8. Rename branch to main if needed

```bash
dotfiles branch -m master main
```

## 9. Push to GitHub

```bash
dotfiles push -u origin main
```

---

# 📥 Part 2: Cloning and setting up dotfiles on a new machine

## 1. Clone the bare repository

```bash
git clone --bare git@github.com:janthmueller/dotfiles-ubuntu.git $HOME/.dotfiles
```

## 2. Set Git alias (if not yet done)

```bash
if ! grep -q "alias dotfiles=" ~/.bashrc; then
  echo "alias dotfiles='/usr/bin/git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'" >> ~/.bashrc
  source ~/.bashrc
fi

# Temporary alias for the current session
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```

## 3. Checkout your dotfiles

```bash
dotfiles checkout
```

> ⚠️ If checkout fails due to existing files, continue to the next step.

## 4. Backup existing conflicting files (if needed)

```bash
mkdir -p .dotfiles-backup
dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | while read -r file; do
    mkdir -p "$(dirname ".dotfiles-backup/$file")"
    mv "$file" ".dotfiles-backup/$file"
done

dotfiles checkout
```

## 5. Hide untracked files

```bash
dotfiles config --local status.showUntrackedFiles no
```

---

# ✅ Done

Your dotfiles are now:

- Tracked by Git
- Backed up on GitHub
- Easy to pull onto any machine
- Managed cleanly inside your `$HOME`

