# History settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt autocd nomatch
bindkey -e

# Completion setup
zstyle :compinstall filename '/home/tcraggs/.zshrc'
autoload -Uz compinit
compinit

# Syntax highlighting and autosuggestions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^I' autosuggest-accept

# Aliasses
alias archbtw='fastfetch'

# Alias to enable dotfiles git commands
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

## Rust GNU utilites
alias sudo='sudo-rs'
alias ls='uu-ls --color=auto'
alias cat='uu-cat'
alias cp='uu-cp'
alias mv='uu-mv'
alias rm='uu-rm'
alias mkdir='uu-mkdir'
alias rmdir='uu-rmdir'

autoload -Uz colors && colors
setopt prompt_subst

PROMPT='%B%{$fg[green]%}%n@%m %{$fg[blue]%}%~ $(if [[ $? != 0 ]]; then echo "%{$fg[red]%}:(%{$fg[blue]%} "; fi)%{$fg[blue]%}$ %b%{$reset_color%}'
