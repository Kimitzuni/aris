# Kimitzuni's Automatic Rice Installation Script (ARIS)

ARIS is the script that I created in order to automate the installation of my dotfiles,
along with the packages that are required to make these work, and the Git repositories
of programs that I use, and other stuff.

While the script was created for my own personal use, I did decide to put it on
[GitHub](https://github.com/Kimitzuni/aris) and [GitLab](https://gitlab.com/Kimitzuni/aris) for
2 reasons. 1 - So that other people can use it, and 2 - so that it was easier for me
to use it. The script was created so that I can just install a minimal Arch or Artix setup,
with just the essential packages, such as `base grub networkmanager dhcpcd` etc., and then
just download and run this script, which will install everything I want and need.

## The Packages CSV File
The script reads the file [`packages.csv`](packages.csv) to know which packages it has
to install. The packages can come from 3 different locations, which are all denoted by
the first column of the file:

> `P` - The packages are in the default Arch Linux `pacman` repos; \
> `A` - The packages are in the [Arch User Repository](https://aur.archlinux.org); \
> `G` - The "packages" are a Git Repository.

There are some others in this, but these are just for Artix, where the init system is not
`systemd`, and so you need packages built for the init system you've chosen. I've made it
so that the script detects which init system is being used, and will automatically pick the
ones for that init system.

## Using ARIS
ARIS will work on a minimal install of Arch Linux or Artix Linux. Distributions based on
Arch, such as Manjaro; EndeavourOS; ArcoLinux, haven't been tested. They may work, however
I cannot confirm nor deny this as I don't use these distributions.

Additionally, the script will overwrite any existing dotfiles that you may have installed,
so it is advised that you create a backup of these before you start.

The script must also be ran as the **root** user, either via `sudo` or by logging in as 
the root user. This is to create as little user interaction as possible, so that it can
be a kind of unattanded installation. However, you will need a user on the system to install
the dotfiles to. This script will not add any users.

To run ARIS, you simply just need to run this:

```
curl https://kimitzuni.github.io/aris/aris.sh | bash
```

## TODO/Planned Features

### Optional Package Choices
In the future, I may add the ability for optional packages, as currently the script also
installs the LaTeX suite, which not everyone is going to need, want or know how to use. This
suite is also roughly 2GB in size, and so having the ability to optionally install packages
is a good idea. I may do that.

### Creating Users
I also may add the ability for the script to create a user if no user is found on the system,
however, because I add a user on the system when installing the base system, I don't know if
I'd actually implement this.

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
