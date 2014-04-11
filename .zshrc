#!/bin/zsh -x
#
# Example .zshrc file for zsh 4.0
#
# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#

# Search path for the cd command
#cdpath=(.. )

# Use hard limits, except for a smaller stack and no core dumps
unlimit


# alias for do something and tell me with dzen when you're done:
alias go=~/bin/executeAndNotify.sh

# set xterm titles with each command
#case $TERM in
#    xterm*)
#        precmd () {print -Pn "\e]0;%n@%m: %~\a"}
#        ;;
#esac

# Set up aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias cp='nocorrect scp'       # no spelling correction on scp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
#alias j=jobs   # I never used this 
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias h=history

## LS Shortcuts

autoload colors; colors;
#export LSCOLORS="Gxfxcxdxbxegedabagacad"
eval "$(dircolors)"

alias ls='ls -Gp --color=auto'
alias ll='ls -lphG'
alias la='ls -laphG'
alias lt='ls -ltphG'
alias lr='ls -ltphGr'

alias ec='emacsclient'
alias e='emacsclient -n'

alias cpc='find . -name "*.pyc" -print0 | xargs --null rm'

# List only directories and symbolic
# links that point to directories
alias lsd='ls -ld *(-/DN)'

# List only file beginning with "."
alias lsa='ls -ld .*'

# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

bzrev() {
    echo "Pulling in trunk..."
    cd trunk
    bzr pull
    cd ../
    branchname=`basename "$1"`
    bzr branch "lp:$1" review-$branchname
    bzr diff --old=trunk --new=review-$branchname > review-$branchname/$branchname-vs-trunk.diff
    echo "view the diff:\nec -n review-$branchname/$branchname-vs-trunk.diff"
}

#old
bzrevcolo() {
    curbranch=`bzr colo-branches | grep "^\* " | cut -f 2 -d ' '`
    branchname=`basename "$1"`
    bzr colo-branch --from-branch="lp:$1" review-$branchname
    bzr diff --old=colo:$curbranch > review-$branchname-vs-$curbranch.diff
    echo "view the diff:\nec -n review-$branchname-vs-$curbranch.diff"
}

# Where to look for autoloaded function definitions
fpath=(~/zsh_funcs $fpath)

# handle emacs not setting terminal type properly:

[[ $EMACS = t ]] && unsetopt zle

# Global aliases -- These do not have to be
# at the beginning of the command line.
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'

# Some environment variables
export LESS=-cex3M
export HELPDIR=/usr/local/lib/zsh/help  # directory for run-help function to find docs

# source environment stuff
source $HOME/.environment


# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

setopt                       \
     NO_all_export           \
        always_last_prompt   \
    always_to_end        \
        append_history       \
        auto_list            \
        auto_menu            \
     NO_auto_name_dirs       \
        auto_param_keys      \
        auto_param_slash     \
        auto_remove_slash    \
     NO_auto_resume          \
        bad_pattern          \
        bang_hist            \
     NO_beep                 \
     NO_brace_ccl            \
        correct_all          \
     NO_bsd_echo             \
        cdable_vars          \
     NO_chase_links          \
     NO_clobber              \
        complete_aliases     \
        complete_in_word     \
     NO_correct              \
        correct_all          \
        csh_junkie_history   \
     NO_csh_junkie_loops     \
     NO_csh_junkie_quotes    \
     NO_csh_null_glob        \
        equals               \
        extended_glob        \
        extended_history     \
        function_argzero     \
        glob                 \
     NO_glob_assign          \
    NO_glob_complete        \
     NO_glob_dots            \
        glob_subst           \
        hash_cmds            \
        hash_dirs            \
        hash_list_all        \
     NO_hup                  \
     NO_ignore_braces        \
     NO_ignore_eof           \
        interactive_comments \
        NO_ksh_glob             \
     NO_list_ambiguous       \
     NO_list_beep            \
        list_types           \
        long_list_jobs       \
        magic_equal_subst    \
     NO_mail_warning         \
     NO_mark_dirs            \
    NO_menu_complete\
        multios              \
        nomatch              \
        notify               \
     NO_null_glob            \
        numeric_glob_sort    \
     NO_overstrike           \
        path_dirs            \
        posix_builtins       \
     NO_print_exit_value     \
     prompt_cr            \
        prompt_subst         \
        pushd_ignore_dups    \
     NO_pushd_minus          \
     NO_pushd_silent         \
        pushd_to_home        \
        rc_expand_param      \
     NO_rc_quotes            \
     NO_rm_star_silent       \
     NO_sh_file_expansion    \
        sh_option_letters    \
        short_loops          \
        sh_word_split        \
     NO_single_line_zle      \
     NO_sun_keyboard_hack    \
        unset                \
     NO_verbose              \
        zle

setopt NO_rm_star_wait


# HISTORY stuff

HISTSIZE=200000
SAVEHIST=100000
HISTFILE=$HOME/.zsh_history
DIRSTACKSIZE=20

setopt                       \
    share_history \
    hist_ignore_dups \
    hist_expire_dups_first \
    hist_find_no_dups \
    hist_no_functions      \
    hist_no_store \
    hist_reduce_blanks \
    hist_allow_clobber   \
    hist_beep            \
    hist_ignore_space

#        list_packed            \


# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

# Some nice key bindings
#bindkey '^X^Z' universal-argument ' ' magic-space
#bindkey '^X^A' vi-find-prev-char-skip
#bindkey '^Xa' _expand_alias
#bindkey '^Z' accept-and-hold
#bindkey -s '\M-/' \\\\
#bindkey -s '\M-=' \|

# bindkey -v               # vi key bindings

bindkey -e                 # emacs key bindings
bindkey ' ' magic-space    # also do history expansion on space
#bindkey '^I' complete-word # complete on tab, leave expansion to _expand

# stuff from someone else's .zsh:

#bindkey "^X^I" expand-or-complete-prefix

# {{{ Environment variables

# See man page strftime(3) for more details.
MY_DATE="%D{%a %d %b %Y}"
MY_TIME="%D{%H:%M:%S}"

if (( EUID == 0 ))
then
    COLOR_ROOT_BOLD="%{"$'\e[01m'"%}"
    COLOR_RESET="%{"$'\e[39;49;01m'"%}"
else
    COLOR_ROOT_BOLD=""
    COLOR_RESET="%{"$'\e[39;49;00m'"%}"
fi

COLOR_REAL_RESET="%{"$'\e[39;49;00m'"%}"

colorize()
{
    COLOR_p_h="%{"$'\e[30;49m'"%}"
    COLOR_p_l="%{"$'\e[30;49m'"%}"
    COLOR_p_y="%{"$'\e[30;49m'"%}"

    COLOR_p_n="%{"$'\e[30;49m'"%}"
    COLOR_at="%{"$'\e[30;49m'"%}"
    COLOR_p_m="%{"$'\e[30;49m'"%}"

    COLOR_WHOLEHOST="%{"$'\e[30;49m'"%}"
    COLOR_SHORTHOST="%{"$'\e[30;49m'"%}"
    COLOR_DOMAINHOST="%{"$'\e[30;49m'"%}"

    COLOR_p_D="%{"$'\e[30;49m'"%}"
    COLOR_MY_DATE="%{"$'\e[30;49m'"%}"
    COLOR_p_star="%{"$'\e[30;49m'"%}"
    COLOR_MY_TIME="%{"$'\e[30;49m'"%}"

    COLOR_ROOT="%{"$'\e[01;30;49m'"%}"

    if (( EUID == 0 ))
    then
        COLOR_p_hash="${COLOR_ROOT}"
        COLOR_p_slash="${COLOR_ROOT}"
    else
        COLOR_p_hash="%{"$'\e[01;03;30;49m'"%}"
        COLOR_p_slash="%{"$'\e[30;49m'"%}"
    fi

    $LATEST_PROMPT
}
if [[ $NONTERMINAL == yeah ]] then
    export PS1="b--m++"
    export TERM=dumb
else
    colorize
    export PS1="${COLOR_ROOT_BOLD}${COLOR_p_h}%h${COLOR_RESET} ${COLOR_ROOT_BOLD}${COLOR_ROOT}%S${ROOTTEXT}%s${COLOR_RESET}$ROOTPROMPTADD${COLOR_p_n}%n${COLOR_RESET}${COLOR_at}@${COLOR_RESET}${COLOR_p_m}%m${COLOR_RESET} | ${COLOR_MY_DATE}${MY_DATE}${COLOR_RESET} ${COLOR_MY_TIME}${MY_TIME}${COLOR_RESET}%E
${COLOR_p_slash}%/${COLOR_RESET}
${COLOR_p_hash}%#${COLOR_REAL_RESET} "
    
#export RPROMPT=""

fi

# {{{ Completions

# {{{ Set up new advanced completion system

# needs new version:

  autoload -U compinit
  compinit -C # don't perform security check


# }}}
# {{{ Completion caching

#zstyle ':completion::complete:*' use-cache 1
#zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# }}}
# {{{ Expand partial paths

zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# }}}
# {{{ Include non-hidden dirs in globbed file completions for certain commands

#zstyle ':completion::complete:*' \
#  tag-order 'globbed-files directories' all-files 
#zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# }}}
# {{{ Don't complete backup files as executables

zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# }}}
# {{{ Don't complete uninteresting users

zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

# }}}
# {{{ Output formatting

zmodload -i zsh/complist


# change format for local directories
#zstyle ':completion:*:cd:*:descriptions' format '*** %d %f'
#zstyle -s :completion::complete:cd::local-directories group-name gname

# }}}
# {{{ Completion for processes

zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always


# zstyle -e ':completion:*:ssh:*' hosts \
#     'reply=($(sed -e "/^#/d" -e "s/ .*\$//" -e "s/,/ /g" \
#     /etc/ssh_known_hosts ~/.ssh/known_hosts 2>/dev/null))'
# zstyle ':completion:*' hosts $hosts



# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' format '%B--- %d%b'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-:]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/Users/mmccrack/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
    }
    function zle-line-finish () {
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi
