# Kimitzuni's Automatic Rice Installation Script (ARIS)
```
            _     
  __ _ _ __(_)___ 
 / _` | '__| / __|
| (_| | |  | \__ \
 \__,_|_|  |_|___/
```

ARIS is the script that I created to automate the installation of the packages
that are needed to make my dotfiles work, along with installing the dotfiles
themselves.

This script will work on a clean Arch or Artix Linux installation, and will
install the packages that are specified in [packages.csv](package.csv). The
script must be ran as root, **not** as the user you want to install the
dotfiles to.

## `packages.csv`
The `packages.csv` file contains the list of packages that will be installed
onto the system. These can be from the default `pacman` repositories, the
Arch User Repository or a custom Git Repository. These are denoted with the
first column of the CSV file.

> `P` refers to the Pacman Repos \
> `A` refers to the AUR \
> `G` refers to Git Repositories.

There are some others in the file, but these are just for the Artix users,
where `systemd` packages are not present, and these are just packages for
each of the init systems that you can use on Artix - OpenRC, Runit, Dinit
and S6.

## Using ARIS
To use ARIS, you do not need to clone the Git repository (though you can
if you want to). To use ARIS, you simply need to run the following command:

```
curl -fLs https://gitlab.com/Kimitzuni/aris/-/raw/master/aris.sh | bash
```
