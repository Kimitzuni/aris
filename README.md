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

This script was created for my own personal use, but I decided that I should
share it incase there are others that want to use my dotfiles, and don't want
to spend time doing everything manually. And also I'm lazy.

This script will work on a clean Arch or Artix Linux installation, and will
install the packages that are specified in [packages.csv](packages.csv). The
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
curl https://kimitzuni.github.io/aris/aris.sh | bash
```

## LICENSE
```
Copyright (C) Rebecca White         <rtw@null.net>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
```
