# +-----------------------------------------------------------------+
# | ZSHRC                                                           |
# +-----------------------------------------------------------------+

# +-----------------------------------------------------------------+
# | Variables                                                       |
# +-----------------------------------------------------------------+
CACHE=${XDG_CACHE_HOME:-$HOME/.cache}
CONFIG=${XDG_CONFIG_HOME:-$HOME}
ZDOTDIR="${ZDOTDIR:-$CONFIG/.zsh}"
ZPLUGINSDIR="${ZDOTDIR}/plugins"
ZSNAPDIR="${ZPLUGINSDIR}/zsh-snap"

# +-----------------------------------------------------------------+
# | Plugin Manager: zsh-snap                                        |
# +-----------------------------------------------------------------+
# | https://github.com/marlonrichert/zsh-snap                       |
# +-----------------------------------------------------------------+

plugins=(\
  "ohmyzsh/ohmyzsh" \
  "sorin-ionescu/prezto" \
  "marlonrichert/zsh-autocomplete" \
  "marlonrichert/zsh-edit" \
  "marlonrichert/zsh-hist" \
  "zdharma/fast-syntax-highlighting" \
  "romkatv/powerlevel10k" \
)

plugin() {
  plugin_name=$(echo $1 | cut -d "/" -f 2)
  if [[ ! -d $ZPLUGINSDIR/$plugin_name ]]; then
    znap clone $1
  fi
  znap source $plugin_name
}

# Make ZDOTDIR & ZSNAPDIR if doesn't exist
[[ -d $ZPLUGINSDIR ]] || mkdir -p $ZPLUGINSDIR
[[ -d $ZSNAPDIR ]] || git clone https://github.com/marlonrichert/zsh-snap $ZSNAPDIR

# Set zsh-snap plugin dir
zstyle ':znap:*' plugins-dir $ZPLUGINSDIR

# Load zsh-snap
source $ZSNAPDIR/znap.zsh

# Clone all of our plugins
znap clone

# Set prompt
znap prompt adam1

# +-----------------------------------------------------------------+
# | Keybindings                                                     |
# +-----------------------------------------------------------------+
znap source "marlonrichert/zsh-edit"
# Use emacs keybindings
bindkey -e

# +-----------------------------------------------------------------+
# | History                                                         |
# +-----------------------------------------------------------------+
znap source "marlonrichert/zsh-hist"
znap source prezto modules/history
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=${ZDOTDIR}/.history
setopt HistIgnoreAllDups             # Dont add duplicate history entries
setopt ShareHistory                  # Share history b/w instances
bindkey '^[q' push-line-or-edit

# +-----------------------------------------------------------------+
# | Colors                                                          |
# +-----------------------------------------------------------------+
znap source ohmyzsh lib/theme-and-appearance

# Syntax Highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=( main brackets pattern cursor )
znap source "zdharma/fast-syntax-highlighting"

eval "$(dircolors -b)"
# zstyle ':completion:*:' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''

# +-----------------------------------------------------------------+
# | Completions                                                     |
# +-----------------------------------------------------------------+
if (( $+commands[pipenv] )); then
  znap eval pipenv-completion 'pipenv --completion'
fi
# This includes the full path to `direnv` in the command string, so that the cache will be
# regenerated whenever the version of `direnv` changes.
if (( $+commands[asdf] )); then
  znap eval asdf-direnv "asdf exec $(asdf which direnv) hook zsh"
fi

# +-----------------------------------------------------------------+
# | Completion                                                      |
# +-----------------------------------------------------------------+

# Fancy autocomplete
znap source "marlonrichert/zsh-autocomplete"

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'


# +-----------------------------------------------------------------+
# | Aliases                                                         |
# +-----------------------------------------------------------------+
# Source all of our aliases
[[ -f $CONFIG/.aliases ]] && source $CONFIG/.aliases
