# PACKAGES
##########
# https://wiki.archlinux.org/index.php/Pacman_Tips#Backing_up_and_retrieving_a_list_of_installed_packages
# backup installed packages (alternatively use aura -B and auro -Br)
#comm -23 <(pacman -Qeq|sort) <(pacman -Qmq|sort) > pkglist.txt
# restore
#pacman -S --needed $(comm -12 <(pacman -Slq|sort) <(sort badpkdlist) )


# VIM
#####
# https://github.com/tpope/vim-pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle; \
curl -Sso ~/.vim/autoload/pathogen.vim \
	https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle

# https://github.com/tpope/vim-sensible
git clone git://github.com/tpope/vim-sensible.git
# otherwise it puts the files in the current directory
mkdir -p ~/.local/share/vim/{swap,backup,undo}

# https://github.com/altercation/vim-colors-solarized
git clone git://github.com/altercation/vim-colors-solarized.git

