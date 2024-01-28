#!/bin/bash
#     _    ____  ___ ____  
#    / \  |  _ \|_ _/ ___| 
#   / _ \ | |_) || |\___ \ 
#  / ___ \|  _ < | | ___) |
# /_/   \_\_| \_\___|____/ 
# ARIS
# Automatic Rice Installation Script
# ==============================================================================

PackagesCSV="/tmp/packages.csv"
PackagesCSV_URL="https://gitlab.com/Kimitzuni/aris/-/raw/master/packages.csv"
[ ! -f "$PackagesCSV" ] && curl -s $PackagesCSV_URL -o $PackagesCSV

##
## VARIABLES
##
PacmanPackages="$(awk -F, '/^P,/ {print $2}' $PackagesCSV | tr '\n' ' ')"
AURPackages="$(awk -F, '/^A/ {print $2}' $PackagesCSV)"
GitRepos="$(awk -F, '/^G/ {print $2}' $PackagesCSV)"

NumberPacman="$(awk '/^P/' $PackagesCSV | wc -l)"
NumberAUR="$(awk '/^A/' $PackagesCSV | wc -l)"
NumberGit="$(awk '/^G/' $PackagesCSV | wc -l)"

Packages_Openrc="$(awk -F, '/^P_ORC/ {print $2}' $PackagesCSV | tr '\n' ' ')"
Packages_runit="$(awk -F, '/^P_RUNIT/ {print $2}' $PackagesCSV | tr '\n' ' ')"
Packages_S6="$(awk -F, '/^P_S6/ {print $2}' $PackagesCSV | tr '\n' ' ')"
Packages_dinit="$(awk -F, '/^P_DINIT/ {print $2}' $PackagesCSV | tr '\n' ' ')"
InitSystem="systemd"

InstallForUser=""

##
## FUNCTIONS
##
ARISPrompt() {
	printf "\033[1;95mARIS:\033[0m "
}

DetectInitSystem() {
	InitSystem_Path="$(ls -l /bin/init | awk '{print $11}')"

	[ ! -z "$(echo "$InitSystem_Path" | grep 'openrc' -i)" ] && InitSystem="OpenRC"
	[ ! -z "$(echo "$InitSystem_Path" | grep 's6' -i)" ] && InitSystem="S6"
	[ ! -z "$(echo "$InitSystem_Path" | grep 'dinit' -i)" ] && InitSystem="dinit"
	[ ! -z "$(echo "$InitSystem_Path" | grep 'runit' -i)" ] && InitSystem="runit"
}

ARISBanner() {
	DetectInitSystem
	clear

	printf "\033[1;95m"
	cat << EOF
    _    ____  ___ ____  
   / \\  |  _ \\|_ _/ ___| 
  / _ \\ | |_) || |\\___ \\ 
 / ___ \\|  _ < | | ___) |
/_/   \\_\\_| \\_\\___|____/ 
Automatic Rice Installation Script

EOF

	printf "\033[0m"

	cat << EOF
Welcome to the Automatic Rice Installation Script. This script will install the
packages required for my dotfiles to work, alongwith the dotfiles themselves.
This script will install the following number of packages:

	$NumberPacman from 'pacman'
	$NumberAUR from the Arch User Repository
	$NumberGit from Git Repositories

This script will also overwrite any pre-existing dotfiles that you may have
installed. If you would like to back them up first, press ^C (Ctrl-C) and 
back them up now.

Additionally, this script must also be ran as root, so if you haven't ran
this as a root user, press ^C (Ctrl-C) and re-run it as the root user,
either with 'sudo' or by being the root user.

On the next step, you will select the user that you want to install the dotfiles
for.

When you are ready, simply type 'Ready!'
EOF

	ARISPrompt
	read is_ready

	case "$is_ready" in
		"Ready!") SelectUser && ModifyPacmanConf && InstallPackages && \
			InstallAURPackages && InstallGITRepos && \
			CompletedBanner;;
		*) ARISBanner;;
	esac
}

SelectUser() {
	ListOfUsers="$(ls /home --ignore="lost+found")"
	which_user=""

	clear
	cat << EOF
Because ARIS runs as the root user, we will need to select the user that the 
dotfiles will be installed for. Which user would you like to install them for?

$ListOfUsers

EOF

	ARISPrompt
	read which_user

	[ -d "/home/$which_user" ] && \
		printf ">>> Dotfiles will be installed for \033[1;96m$which_user\033[0m\n" && \
		InstallForUser="$which_user" && return

	[ ! -d "/home/$which_user" ] && \
		printf ">>> ERROR: This user does not exist.\n" && sleep 2 && SelectUser

}

ModifyPacmanConf() {
	sed -i 's/#Parallel/Parallel/;s/#Verbose/Verbose/;s/#Color/Color/' /etc/pacman.conf
}

InstallPackages() {
	printf ">>> Installing \033[1;92m$NumberPacman\033[0m Packages from \033[1;94mpacman\033[0m\n"

	pacman -Syyu --noconfirm
	pacman -S $PacmanPackages --noconfirm

	case $InitSystem in
		"OpenRC") pacman -S $Packages_Openrc --noconfirm;;
		"S6") pacman -S $Packages_S6;;
		"dinit") pacman -S $Packages_dinit;;
		"runit") pacman -S $Packages_runit;;
	esac
}

InstallAURPackages() {
	printf ">>> Installing \033[1;92m$NumberAUR\033[0m Packages from \033[1;94mThe Arch User Repository\033[0m\n"
	
	printf ">>> You may be asked to provide the password for \033[1;92m$InstallForUser\033[0m\n\n"
	sleep 2

	for i in $AURPackages; do
		git clone "https://aur.archlinux.org/$i.git" /opt/$i
		cd /opt/$i

		chown $InstallForUser:$InstallForUser /opt/$i
		sudo -u $InstallForUser makepkg -s
		pacman -U *.pkg.tar.zst --noconfirm 
	done
}

InstallGITRepos() {
	printf ">>> Cloning Git Repositories\n"

	for i in $GitRepos; do
		GitSlugName="$(echo "$i" | sed 's/https:\/\/git.*\///g;s/.git//g')"
		git clone $i /opt/$GitSlugName

		cd /opt/$GitSlugName
		chown $InstallForUser:$InstallForUser . -R

		case $GitSlugName in
			"artixrice") InstallRice;;
			"wallpapers") RandomVariable=1;;
			*) make && make install;;
		esac
	done

}

InstallRice() {
	printf ">>> Installing the \033[1;96martixrice\033[0m\n"

	cd /opt/artixrice
	cp -r .config .local .zshrc .bashrc .bash_profile .xinitrc /home/$InstallForUser
	
	printf ">>> Adjusting Permissions...\n"
	chown $InstallForUser:$InstallForUser /home/$InstallForUser/.config -R
	chown $InstallForUser:$InstallForUser /home/$InstallForUser/.local -R
	chown $InstallForUser:$InstallForUser /home/$InstallForUser/.zshrc
	chown $InstallForUser:$InstallForUser /home/$InstallForUser/.bashrc
	chown $InstallForUser:$InstallForUser /home/$InstallForUser/.xinitrc
	chown $InstallForUser:$InstallForUser /home/$InstallForUser/.bash_profile
}

CompletedBanner() {
	sleep 2
	clear

	printf "\033[1;96m"

	cat << EOF
    _    ____  ___ ____  
   / \\  |  _ \\|_ _/ ___| 
  / _ \\ | |_) || |\\___ \\ 
 / ___ \\|  _ < | | ___) |
/_/   \\_\\_| \\_\\___|____/ 
EOF

	printf "\033[0m"

	cat << EOF
Installation has completed! You can now log into the user $InstallForUser, and
use the dotfiles!

Have fun!
EOF

	exit
}
ARISBanner
