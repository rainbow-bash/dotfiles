path+=('/home/marcig/go/bin') 
path+=('/home/marcig/.cargo/bin')
export EDITOR="nvim"
export MANPAGER="nvim +Man!"
HISTFILE=~/.zsh_history
COMBAG_DB_DSN=postgres://combag:memo@localhost/combag
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Download Znap, if it's not there yet.
[[ -r ~/github/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/github/znap
source ~/github/znap/znap.zsh  # Start Znap

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
# zstyle ':completion:*' menu select
autoload edit-command-line; zle -N edit-command-line
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
znap source zsh-completions
znap source zsh-syntax-highlighting
znap source mafredri/zsh-async
znap source momo-lab/zsh-abbrev-alias
znap source ael-code/zsh-colored-man-pages
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line -w
  else
    zle push-input -w
    zle clear-screen -w
  fi
}

lazygit-ctrl-g () {
	lazygit
}

open-vim-oil () {
	nvim -c Oil "$@"
}

make-run () {
	make run
}

tatch () {
	tmux attach -t $1
}

kpop () {
	xclip -sel c
}

fe() {
local files
  IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && $EDITOR "${files[@]}"
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

svim () {
  if [[ -z "$@" ]]; then
		if [[ -f "./Session.vim" ]]; then
				nvim -S Session.vim -c 'lua vim.g.savesession = true'
		else
				nvim -c 'lua vim.g.savesession = true'
		fi
			else
				nvim "$@"
	fi
}

yt () {
	yt-dlp $1 -o $2 -t mp4
}

function murder() {
  kill -9 $(lsof -t -i:$1 -sTCP:LISTEN)
}

function rust() {
	cargo new $1
	cd $1
	vim
}

zle -N fancy-ctrl-z
bindkey '^z' fancy-ctrl-z

zle -N lazygit-ctrl-g
bindkey '^g' lazygit-ctrl-g

zle -N y
bindkey '^y' y

zle -N open-vim-oil
bindkey '^e' open-vim-oil

autoload edit-command-line
zle -N edit-command-line
bindkey '^o' edit-command-line

eval "$(zoxide init zsh)" 
autoload -U colors && colors	
PS1="%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}%b"
alias cd=z
alias src="source  ~/.zshrc"
alias config="nvim ~/dotfiles/zsh/.zshrc"
alias s="kitten ssh"
alias vim=svim
