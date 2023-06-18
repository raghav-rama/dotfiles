#!/bin/bash

### What tf is this, anyway? ###
# i originally wrote this script for automating the dev env setup for Linode
# but it can be used on any fresh ubuntu installation
### Features ###
# sets up solana-cli, rust toolchain, cargo, anchor-cli, node.js, and nvim editor
# basically saves ur time from manually installing everything so u can
# focus more on buidling!
### Notes ###
# it will take around 15-30 mins for this script to execute fully
# so please be patient 😅
# this script works on ubuntu 20.04 LTS
# basically creates a new user geek and sets ups the dev environment
# cheers!
### Instructions ###
# run this from root terminal, i.e. preferably on a fresh ubuntu install
# if your installation is not fresh then skip user creation step in script and
# remove $exec_geek from beginning of all commands and run normally in your terminal
# 🔴 also this script assumes that the default shell is oh-my-zsh,
# so might wanna change .zshrc to .bashrc etc.
# if you want any help pls contact me on twitter, link in profile

apt update

touch /tmp/userlist
echo geek >> /tmp/userlist


userfile=/tmp/userlist 

username=$(cat /tmp/userlist | tr 'A-Z'  'a-z')

password=123

for user in $username
do
       useradd -m $user
       echo -en $password'\n'$password'\n' | passwd $user
done

echo "$(wc -l /tmp/userlist) users have been created" 
tail -n$(wc -l /tmp/userlist) /etc/passwd

apt install sshpass

ssh-keygen -f "/root/.ssh/id_rsa" -P ""
sshpass -p 123 ssh-copy-id -i "/root/.ssh/id_rsa" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no geek@localhost

usermod -aG sudo geek

exec_geek='ssh -o 'UserKnownHostsFile=/dev/null' -o 'StrictHostKeyChecking=no' geek@localhost'
nvm='. .nvm/nvm.sh && source .zshrc && '


$exec_geek 'echo '123' | sudo -S add-apt-repository -y ppa:git-core/ppa'
$exec_geek 'echo '123' | sudo -S apt update'
$exec_geek 'echo '123' | sudo -S apt install git ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen build-essential libudev-dev libssl-dev gcc -y'

$exec_geek 'git config --global user.email hackerer528@gmail.com'
$exec_geek 'git config --global user.name raghav-rama'
$exec_geek 'git config --global user.signingkey ~/.ssh/id_ed25519_hackerer528.pub'
$exec_geek 'git config --global gpg.format ssh'
$exec_geek 'chmod 400 .ssh/id_ed25519_hackerer528'

$exec_geek 'echo '123' | sudo -S apt install zsh -y'
$exec_geek 'echo '123' | chsh --shell /usr/bin/zsh'
$exec_geek 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

$exec_geek 'curl https://sh.rustup.rs -sSf | sh -s -- --default-host x86_64-unknown-linux-gnu  --default-toolchain nightly --profile default -y'
$exec_geek 'source .zshrc'

$exec_geek 'sh -c "$(curl -sSfL https://release.solana.com/beta/install)"'

#GEEK_PATH=$(su - geek -c env | grep PATH)
#GEEK_PATH=${PATH=/}
$exec_geek 'echo 'export PATH=/home/geek/.local/share/solana/install/active_release/bin:/home/geek/.local/bin:\$PATH' >> .zshrc'
$exec_geek 'source .zshrc'

$exec_geek 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash'
$exec_geek 'source .zshrc'
$exec_geek $nvm 'nvm install node'
$exec_geek $nvm 'npm i -g corepack'
$exec_geek $nvm 'corepack enable'
$exec_geek $nvm 'corepack prepare yarn@stable --activate'

$exec_geek 'cargo install --git https://github.com/coral-xyz/anchor avm --locked --force'
$exec_geek 'source .zshrc'
$exec_geek 'avm install latest'
$exec_geek 'avm use latest'

$exec_geek 'echo 'alias cgbpf="cargo-build-sbf --manifest-path=Cargo.toml --sbf-out-dir=myprogram"' >> .zshrc'
$exec_geek 'source .zshrc'

$exec_geek 'git clone https://github.com/neovim/neovim .neovim'
$exec_geek 'cd .neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo'
$exec_geek 'cd .neovim && echo '123' | sudo -S make install'

$exec_geek 'mkdir -p ~/.local/bin'
$exec_geek 'curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer'
$exec_geek 'chmod +x ~/.local/bin/rust-analyzer'

$exec_geek 'git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions'
$exec_geek 'git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting'
$exec_geek 'git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k'

$exec_geek 'curl -fLo /home/geek/.zshrc https://raw.githubusercontent.com/raghav-rama/dotfiles/main/.zshrc/.zshrc'
$exec_geek 'curl -fLo /home/geek/.AtomicCoding https://raw.githubusercontent.com/raghav-rama/dotfiles/main/.zshrc/.AtomicCoding'
$exec_geek 'curl -fLo /home/geek/.config/nvim/init.lua https://raw.githubusercontent.com/raghav-rama/dotfiles/main/nvim/init.lua --create-dirs'
