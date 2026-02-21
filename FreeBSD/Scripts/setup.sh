#!/bin/sh

### ################################################################################################################################

### ################################
### FreeBSD Handbook
### ################################

### https://docs.freebsd.org/en/books/handbook/

### ################################
### FreeBSD Developers' Handbook
### ################################

### https://docs.freebsd.org/en/books/developers-handbook/

### ################################
### FreeBSD FAQs
### ################################

### https://docs.freebsd.org/en/books/faq/

### ################################################################################################################################

### ################################
### Setup Groups
### ################################

pw groupmod wheel -m gabriel
pw groupmod video -m gabriel

### ################################
### Setup Packages
### ################################

pkg bootstrap --yes
pkg update
pkg upgrade --yes

### ################################
### Setup Terminal
### ################################

sysrc allscreens_flags="-f spleen-16x32"

### ################################
### Setup Super User
### ################################

pkg install --yes sudo
cat << 'EOF' | tee "/usr/local/etc/sudoers.d/wheel" > "/dev/null"
%wheel ALL=(ALL:ALL) ALL
EOF
chmod 0440 "/usr/local/etc/sudoers.d/wheel"

### ################################
### Setup Do As
### ################################

pkg install --yes doas
cat << 'EOF' | tee "/usr/local/etc/doas.conf" > "/dev/null"
permit persist :wheel
EOF
chmod 0440 "/usr/local/etc/doas.conf"

### ################################################################################################################################

### ################################
### Setup Desktop Environment
### ################################

sudo pkg install --yes desktop-installer
desktop-installer

### ################################################################################################################################

### ################################
### Setup Shell
### ################################

cat << 'EOF' | tee -a "$HOME/.shrc" | sudo tee -a "/root/.shrc" > "/dev/null"
### ################################
### SHELL ENVIRONMENT
### ################################

C_RED='\[\e[1;31m\]'
C_GREEN='\[\e[1;32m\]'
C_YELLOW='\[\e[1;33m\]'
C_BLUE='\[\e[1;34m\]'
C_PURPLE='\[\e[1;35m\]'
C_CYAN='\[\e[1;36m\]'
C_GRAY='\[\e[1;30m\]'
C_RESET='\[\e[0m\]'

update_prompt() {
	local branch="$(command git symbolic-ref --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null)"
	local git_info=" "

	if [ -n "${branch}" ]; then
		git_info=" ${C_BLUE}(${C_RED}${branch}${C_BLUE})${C_RESET} "
	fi

	export PS1="${C_GREEN}\u${C_BLUE}@${C_PURPLE}\h${C_GRAY}:${C_GRAY}[${C_YELLOW}\w${C_GRAY}]${C_RESET}${git_info}${C_CYAN}\$${C_RESET} "
}
update_prompt

run_and_update() {
	local cmd="$1"
	shift
	command "$cmd" "$@"
	local ret=$?
	update_prompt
	return $ret
}

cd()    { run_and_update cd "$@"; }
rm()    { run_and_update rm "$@"; }
rmdir() { run_and_update rmdir "$@"; }
git()   { run_and_update git "$@"; }
gh()    { run_and_update gh "$@"; }
wget()  { run_and_update wget "$@"; }
curl()  { run_and_update curl "$@"; }
unzip() { run_and_update unzip "$@"; }
tar()   { run_and_update tar "$@"; }
7z()    { run_and_update 7z "$@"; }

### ################################
### SHELL FUNCTIONS
### ################################

### ################################
### SHELL ALIAS
### ################################

### ################################
### SHELL CONFIGURATION
### ################################
EOF

### ################################
### Setup Bash
### ################################

sudo pkg install --yes bash

cat << 'EOF' | tee -a "$HOME/.bashrc" | sudo tee -a "/root/.bashrc" > "/dev/null"
### ################################
### SHELL ENVIRONMENT
### ################################

git_branch() {
	local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
	if [ -n "${branch}" ]; then
		echo "${branch}"
	fi
}

show_git_branch() {
	if git rev-parse --is-inside-work-tree &>/dev/null; then
		local branch="$(git_branch)"
		if [ -n "${branch}" ]; then
			echo "❮\[\e[1;31m\]󰊢 \[\e[1;35m\]${branch}\[\e[0;33m\]❯"
		fi
	fi
}

os_version=$(freebsd-version)
sh_name=$(ps -p $$ -o comm=)
if [ "$(id -u)" -eq 0 ]; then
	usr_color="\[\e[1;31m\]"
else
	usr_color="\[\e[1;32m\]"
fi
update_prompt() {
	PS1="\n\[\e[0;33m\]\[\e[1;31m\] \[\e[1;35m\]${os_version}\[\e[0;33m\]─\[\e[1;34m\] \[\e[1;35m\]${sh_name}\[\e[0;33m\]"
	PS1+="\n\[\e[0;33m\]┌──❮ \[\e[1;32m\] \t\[\e[0;33m\] ❯─❮ \[\e[1;32m\] \D{%d/%m/%y}\[\e[0;33m\] ❯─❮ \[\e[1;33m\] \[\e[1;36m\]\W\[\e[0;33m\] ❯─ ❮\[\e[1;34m\] ${usr_color}\u\[\e[0;33m\]❯ $(show_git_branch)"
	PS1+="\n\[\e[0;33m\]└─\[\e[1;34m\]\[\e[0m\] "
}
PROMPT_COMMAND=update_prompt

### ################################
### SHELL FUNCTIONS
### ################################

### ################################
### SHELL ALIAS
### ################################

### ################################
### SHELL CONFIGURATION
### ################################
EOF

### ################################
### Setup Zsh
### ################################

sudo pkg install --yes zsh
curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | sh -s -- --unattended
curl -fsSL "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh" | sudo sh -s -- --unattended

cat << 'EOF' | tee -a "$HOME/.zshrc" | sudo tee -a "/root/.zshrc" > "/dev/null"
### ################################
### SHELL OPTIONS SETUP
### ################################

# History OPTIONS
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# Globbing & Expansion OPTIONS
setopt EXTENDED_GLOB
setopt GLOB_DOTS
setopt PROMPT_SUBST

# Interaction OPTIONS
setopt CORRECT
setopt INTERACTIVE_COMMENTS
unsetopt BEEP

# Navigation OPTIONS
setopt AUTO_CD

### ################################
### SHELL ENVIRONMENT
### ################################

git_branch() {
	local branch="$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)"
	if [ -n "${branch}" ]; then
		echo "${branch}"
	fi
}

show_git_branch() {
	if git rev-parse --is-inside-work-tree &>/dev/null; then
		local branch="$(git_branch)"
		if [ -n "${branch}" ]; then
			echo "❮%B%F{red}󰊢 %F{magenta}${branch}%b%F{yellow}❯"
		fi
	fi
}

os_version=$(freebsd-version)
sh_name=$(ps -p $$ -o comm=)
if [ "$(id -u)" -eq 0 ]; then
	usr_color="%B%F{red}"
else
	usr_color="%B%F{green}"
fi
export PROMPT=$'
%b%F{yellow}%B%F{red} %F{magenta}${os_version}%b%F{yellow}─%B%F{blue} %F{magenta}${sh_name}%b%F{yellow}
%b%F{yellow}┌──❮ %B%F{green} %*%b%F{yellow} ❯─❮ %B%F{green} %D{%d/%m/%y}%b%F{yellow} ❯─❮ %B%F{yellow} %B%F{cyan}%c%b%F{yellow} ❯─ ❮%B%F{blue} ${usr_color}%n%b%F{yellow}❯ \$(show_git_branch)
%b%F{yellow}└─%B%F{blue}%f%b '

### ################################
### SHELL FUNCTIONS
### ################################

### ################################
### SHELL ALIAS
### ################################

### ################################
### SHELL CONFIGURATION
### ################################
EOF

### ################################################################################################################################
