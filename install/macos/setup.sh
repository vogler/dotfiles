# change default settings
source defaults.sh

# install Command Line Tools of Xcode: git, make, clang, gperf, m4, perl, svn, size, strip, strings, libtool, cpp, what...
xcode-select --install; echo "Press Enter when installed to continue."; read

# install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
