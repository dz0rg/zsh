# vi keyboard
set -o vi

# Include aliases
if [[ -r ~/.zsh_aliases ]]; then
    source ~/.zsh_aliases
fi

# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Export
export EDITOR="vim"
export PAGER="less"
export HISTIGNORE='&:exit:ls'
export HISTCONTROL=ignoredups:ignorespace
export HISTTIMEFORMAT="[ %d/%m/%Y %H:%M:%S ] "

# Open file with mime ex: ./toto.pdf
autoload -U zsh-mime-setup
autoload -U zsh-mime-handler
zsh-mime-setup

# autocompletion
autoload -Uz compinit && compinit
# colors
autoload -U colors && colors
# autocompletion with arrow key 
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BDesole, pas de resultats pour : %d%b'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# autocompletion with sudo
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
# autocomplete with ps, kill
zstyle ':completion:*:processes' command 'ps -ax'
zstyle ':completion:*:processes-names' command 'ps -aeo comm='
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:killall:*:processes-names' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:killall:*' menu yes select

# appends every commands to the history file once it is executed
setopt inc_append_history
# import new commands from the history file also in other zsh-session
setopt share_history
# save each command's beginning timestamp and the duration to the history file
setopt extended_history
# remove the command from the current session history if start by space
setopt histignorespace
# If a new command line being added to the history list duplicates an older
# one, the older command is removed from the list
setopt histignorealldups
# remove command lines from the history list when the first character on the
# line is a space
setopt histignorespace
# ignore twice identical command
setopt hist_ignore_all_dups
setopt noglobdots
# cd /etc -> /etc
setopt autocd

# {{{ Appearance

BLACK="%{"$'\033[01;30m'"%}"
GREEN="%{"$'\033[01;32m'"%}"
RED="%{"$'\033[01;31m'"%}"
YELLOW="%{"$'\033[01;33m'"%}"
BLUE="%{"$'\033[01;34m'"%}"
BOLD="%{"$'\033[01;39m'"%}"
NORM="%{"$'\033[00m'"%}"
export PS1="${RED}[ ${GREEN}%n${NORM}: ${YELLOW}%d${RED} ]${NORM}$ "

# lis with nice colors
LS_COLORS='rs=00:fi=00;32:di=02;36:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=00;35:*.tar=00;31:*.tgz=01;33:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=00;32:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS
# }}}

# {{{ BindKeys

# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

# shift-tab reverse tab 
bindkey '^[[Z' reverse-menu-complete

# Search backwards and forwards with a pattern
bindkey -M vicmd '/' history-incremental-pattern-search-backward
bindkey -M vicmd '?' history-incremental-pattern-search-forward

# set up for insert mode too
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward
# }}}

# {{{ Functions

# show a config file without comments
showconfig () {
	egrep -v "^$|^[[:space:]]*#" "$argv" |less
} 

# create a long password in the clipboard
pass () {
	echo "$argv" |md5sum | cut -d " " -f1 |xclip
}

# show network informations
myIp () {

	echo "--------------- Network Informations ---------------"
	echo "eth0 IP:" `ip addr | awk '/inet .*global/ {print $2}'` " | HW:" `ip addr | awk '/link\/ether/ {print $2}'`
	echo "IP Public: " `curl -s v4.ident.me`
	echo "---------------------------------------------------"
}

# extract archives easily
extract () {

		if [ -f "$argv[1]" ] ; then
		
		case "$argv[1]" in
			*.tar.bz2)   tar xjf "$argv[1]"        ;;
			*.tar.gz)    tar xzf "$argv[1]"     ;;
			*.bz2)       bunzip2 "$argv[1]"       ;;
			*.rar)       unrar x "$argv[1]"     ;;
			*.gz)        gunzip "$argv[1]"     ;;
			*.tar)       tar xf "$argv[1]"        ;;
			*.tbz2)      tar xjf "$argv[1]"      ;;
			*.tgz)       tar xzf "$argv[1]"       ;;
			*.zip)       unzip "$argv[1]"     ;;
			*.Z)         uncompress "$argv[1]"  ;;
			*.7z)        7z x "$argv[1]"    ;;
			*)           echo "'"$argv[1]"' cannot be extracted via extract()" ;;
			esac
		else
			echo "'"$argv[1]"' is not a valid file"
		fi
}


# backup/restore mysql database without the root password
dump_db () {

	local current_time=`date +%d_%m_%Y-%T`

	echo "Backup of "$argv[1]" database on `pwd`"$argv[1]"-$current_time.sql"
	mysqldump --defaults-file=/etc/mysql/debian.cnf --databases --add-drop-table --set-charset "$argv[1]" > "$argv[1]"-$current_time.sql
}

restore_db () {

	local file="$argv[1]"

	if [[ $file =~ ".*-(([0-9]{2})_){2}[0-9]{4}-([0-9]{2}:){2}..*" ]]; then                 # regex date
			local db_name=${file%%-*}               # file="toto-12_23_2022-13:55:02.sql" => db_name=toto
	else

			if [[ ! -z "$argv[2]" ]]; then          # second parameter content db name ?
					local db_name="$argv[2]"
			else                                                            # ask to user
					echo "Please specify the database destination: "
					read db_name
			fi

	fi

	local ext=${file##*.}

	case "$ext" in
			gz|zip) 
					if [[ ${file#*.} =~ "(sql.)?tar.gz" ]]; then            # sql.tar.gz or tar.gz
							extract="tar xzO"
					else                                                    # .sql or .sql.gz
							extract="zcat"
					fi ;;
			bz2) extract="bunzip2" ;;
			tar) extract="tar -xO" ;;
			*) ext="" ;;
	esac

	# check if the db exists and create this is not exists
	if [[ `grep -q "CREATE DATABASE" $file` != 0 ]]; then
			Mysql --exec="CREATE DATABASE IF NOT EXISTS $db_name CHARACTER SET utf8 COLLATE utf8_general_ci;"
	fi

	echo "Restore \"$file\" on \"$db_name\" database"

	if [[ ! -z $ext ]]; then                # extract archive before restore dump
			eval $extract < $file | Mysql $db_name
	else
			Mysql $db_name < $file          # simple sql file
	fi

}
# }}}

# show todo list
tdl list
