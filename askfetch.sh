#!/bin/bash

export TEXTDOMAIN=askfetch
export TEXTDOMAINDIR=$PWD/locale

. gettext.sh

# Function definitions
getColor () {
	local tmp_color=""
	if [[ -n "$1" ]]; then
		if [[ ${BASH_VERSINFO[0]} -ge 4 ]]; then
			if [[ ${BASH_VERSINFO[0]} -eq 4 && ${BASH_VERSINFO[1]} -gt 1 ]] || [[ ${BASH_VERSINFO[0]} -gt 4 ]]; then
				tmp_color=${1,,}
			else
				tmp_color="$(tr '[:upper:]' '[:lower:]' <<< "${1}")"
			fi
		else
			tmp_color="$(tr '[:upper:]' '[:lower:]' <<< "${1}")"
		fi
		case "${tmp_color}" in
			# Standards
			'black')					color_ret='\033[0m\033[30m';;
			'red')						color_ret='\033[0m\033[31m';;
			'green')					color_ret='\033[0m\033[32m';;
			'brown')					color_ret='\033[0m\033[33m';;
			'blue')						color_ret='\033[0m\033[34m';;
			'purple')					color_ret='\033[0m\033[35m';;
			'cyan')						color_ret='\033[0m\033[36m';;
			'yellow')					color_ret='\033[0m\033[1;33m';;
			'white')					color_ret='\033[0m\033[1;37m';;
			# Bolds
			'dark grey'|'dark gray')	color_ret='\033[0m\033[1;30m';;
			'light red')				color_ret='\033[0m\033[1;31m';;
			# Manjaro
			'light green')				color_ret='\033[0m\033[1;32m';;
			'light blue')				color_ret='\033[0m\033[1;34m';;
			'light purple')				color_ret='\033[0m\033[1;35m';;
			'light cyan')				color_ret='\033[0m\033[1;36m';;
			'light grey'|'light gray')	color_ret='\033[0m\033[37m';;
			# Some 256 colors
			'orange')					color_ret="$(colorize '202')";; #DarkOrange
			'light orange') 			color_ret="$(colorize '214')";; #Orange1
			# HaikuOS
			'black_haiku') 				color_ret="$(colorize '7')";;
			#ROSA color
			'rosa_blue') 				color_ret='\033[01;38;05;25m';;
		esac
		[[ -n "${color_ret}" ]] && echo "${color_ret}"
	fi
}

# Flag and Argument parsing
# check flags

while getopts l: option
do
	case "${option}" in
		l ) 
		
			if [[ ${OPTARG} == "el" ]]; then
				export LANGUAGE=el
			elif [[ ${OPTARG} == "en" ]]; then
				export LANGUAGE=en
			else 
				printf $(gettext "Error: Unrecognized locale") ; printf "\n"
			fi
			;; #get locale option
	esac
done

#####UserInfo
user_name=$(whoami)
user_hostname=$( uname -n )

#####Distro
distro=$( hostnamectl | grep Operating\ System | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
distro_id=$( cat /etc/os-release | grep "ID=" | cut -d '=' -f2 )

# if thgere isn't any available stick to the default tux
if [ ! -e "$PWD"/logos/"$distro_id".txt ]; then
    distro_id="default"
fi

arch=$( hostnamectl | grep Architecture: | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
kernel=$( hostnamectl | grep Kernel | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
cpu=$( cat /proc/cpuinfo | grep model\ name | uniq | cut -d ":" -f2 | sed -e 's/^[ \t]*//' )

#####Memory in use (MemTotal-MemFree) - (Buffers+CachedMemory)

###Total RAM memory
ram_total=$( cat /proc/meminfo | grep MemTotal | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
number_total=${ram_total::len-3}
total_mb=$(( $number_total / 1024 )) 

### MemFree Memory
ram_free=$( cat /proc/meminfo | grep MemFree | cut -d ':' -f2 | sed -e 's/^[ \t]*//' )
number_free=${ram_free::len-3}

###Buffers Memory
ram_buffer=$( cat /proc/meminfo | grep Buffers | cut -d ':' -f2 | sed -e 's/^[ \t]*//') 
number_buffer=${ram_buffer::len-3}

###Cached Memory
ram_cached=$( cat /proc/meminfo | grep Cached: | head -n1 | cut -d ':' -f2 | sed -e 's/^[ \t]*//'  )
number_cached=${ram_cached::len-3}

###Used Memory
ram_used=$(( ( $number_total - $number_free ) - ( $number_buffer + $number_cached ) )) 
used_mb=$(( $ram_used / 1024 ))


## Add distribution logo

### Define tabs for better printing
tabs 1

c0=$'\033[0m' # Reset Text


#Get proper logo for distro

logo_file_color=$(cat $PWD/logos/$distro_id.txt | grep "color: " | cut -d ':' -f2 | tr -d '\n' | tr -d '\r' | sed -e 's/^[[:space:]]*//') #remove trailing and leading chars

c1=$(getColor "${logo_file_color}")

#c1=$(getColor 'light green') # Green
logo_color=$(printf "$c1") # generate escape character for color https://unix.stackexchange.com/a/45954 
logo=$(cat $PWD/logos/$distro_id.txt | awk 'BEGIN{ found=0} {if (found) print } /logo\:/{found=1} ' |  sed "s/\$/$c0/ ; s/^/$logo_color/")

#Add reset text string c0 before every newline

#Build system info with i18n

operating_system=$(eval_gettext "Operating system: \$distro")
architecture=$(eval_gettext "Architecture: \$arch")
kernel_ver=$(eval_gettext "Kernel: \$kernel")
cpu_model=$(eval_gettext "CPU: \$cpu")

ram_info_value="$used_mb MB / $total_mb MB"

ram_info=$(eval_gettext "RAM: \$ram_info_value")

systeminfo="\n${c1}${user_name}@${user_hostname}$c0\n$operating_system\n$architecture\n$kernel_ver\n$cpu_model\n$ram_info"

#pr   -i1 -m -J -o1 -t -S"   " <(printf '%b' "${logo}") <(printf '%b' "${systeminfo}") 
 
paste <(printf '%b' "${logo}") <(printf '%b' "${systeminfo}") | column -s $'\t' -t # Thank you stackoverflow user glenn jackman https://unix.stackexchange.com/a/16465
