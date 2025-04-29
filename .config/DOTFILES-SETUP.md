# 🛠 Full Dotfiles Setup Guide

---

## 🖋 Alacritty: Install Nerd Font (for Icons and Symbols)

**What:**  
Alacritty needs a Nerd Font so that special icons (like in file explorers, status bars, prompts) display correctly.

**Why:**  
Without a Nerd Font, you will just see weird boxes or missing characters.

```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
unzip FiraCode.zip
rm FiraCode.zip
```

✅ After installing, set **FiraCode Nerd Font** in your Alacritty config (`~/.config/alacritty/alacritty.toml`):

```toml
[font]
normal = { family = "FiraCode Nerd Font" }
```

---

## 📝 Neovim (nvim): Install Latest Version

**What:**  
Install Neovim manually from the official release binaries.

**Why:**  
Ubuntu's default Neovim version is old. You want the newest features (like Treesitter, LSP, etc.).

**Reference:**  
👉 [Neovim Install Guide](https://github.com/neovim/neovim/blob/master/INSTALL.md)

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

Add Neovim to your PATH (add this line to your `.bashrc`, `.zshrc`, etc.):

```bash
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

✅ Then restart your terminal or `source ~/.bashrc`.

---

## 🛠 Mason, LSP (Neovim): Install Node.js and npm

**What:**  
Mason (Neovim plugin) and many Language Servers (like `pyright` for Python) require Node.js.

**Why:**  
Without Node.js, you cannot install or run important developer tools inside Neovim.

```bash
sudo apt install nodejs npm
```

---

## 🐍 Python Formatters: Install Python Dev Tools

**What:**  
Formatters, linters, and other Python dev tools require `pip`, `venv`, and `setuptools`.

**Why:**  
To use Python language servers, autoformatting (like `black`, `isort`) inside Neovim.

```bash
sudo apt install python3-pip python3-venv python3-setuptools python3-wheel
```

---

## 🔲 tmux: Install Terminal Multiplexer

**What:**  
Install `tmux`, a terminal multiplexer to manage multiple terminal windows easily inside one session.

**Why:**  
For better multitasking: split panes, persistent sessions, plugin ecosystem (like CPU monitor, themes).

```bash
sudo apt install tmux
```

---

## 🔌 TPM (Tmux Plugin Manager): Install Plugins Easily

**What:**  
Install TPM so you can manage and install tmux plugins automatically.

**Why:**  
To easily add themes, status bars, keybinds, and much more to tmux without manual copying.

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

---

## ⚙️ Setup Your `.tmux.conf`

**What:**  
Place your tmux configuration file into your home directory.

**Why:**  
tmux automatically loads configuration from `~/.tmux.conf`.

```bash
cp /path/to/your/dotfiles/.tmux.conf ~/
```

---

## 🚀 Start tmux and Install Plugins

```bash
tmux
```

Inside tmux:

- Press your prefix (`Ctrl+s`)
- Then press `Shift+i` (capital `I`)

✅ This will install all plugins listed in your `.tmux.conf`.

---

# ✅ Finished

Now you have:

- Nerd Font for Alacritty
- Latest Neovim setup
- Mason and LSP support
- tmux with plugin manager ready

---
