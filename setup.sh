#!/usr/bin/env sh


ROOT=$(cd `dirname $0`; pwd)


begin(){
    printf "==========> $1 \\n"
    printf "==========> Please, press ENTER to continue "
    read -r dummy
}


end() {
    printf "==========> Done \\n"
    printf "\\n"
}


printf "# ====================================================================================================================== #\\n"
printf "#                                                                                                                        #\\n"
printf "#         This script will automatically install some essential packages to your computer and set some environments      #\\n"
printf "#                                                                                                                        #\\n"
printf "# ====================================================================================================================== #\\n"


begin 'Modify Apt Sources'
sudo echo "
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse

deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
" > /etc/apt/sources.list
sudo apt update
sudo apt upgrade
end


begin 'Install Nvidia Drivers'
sudo ubuntu-drivers devices
sudo ubuntu-drivers autoinstall
end


begin 'Install Miniconda3'
miniconda_sh_path=${ROOT}/packages/Miniconda3-latest-Linux-x86_64.sh
chmod +x ${miniconda_sh_path}
${miniconda_sh_path}
end


begin 'Modify Conda Sources'
echo "
channels:
  - defaults
show_channel_urls: true
auto_activate_base: false
channel_alias: https://mirrors.tuna.tsinghua.edu.cn/anaconda
default_channels:
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free
  - https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r
custom_channels:
  conda-forge: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  msys2: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  bioconda: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  menpo: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  pytorch: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
  simpleitk: https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud
" > ~/.condarc
end


begin 'Modify Pip Sources'
if [ ! -d "~/.pip" ]; then
  mkdir ~/.pip
fi
echo "
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
" > ~/.pip/pip.conf
end


if [ ! -d "~/Documents/software" ]; then
  mkdir ~/Documents/software
fi


begin 'Install Nodejs'
node_tar_xz_path=${ROOT}/packages/node-v12.14.1-linux-x64.tar.xz
NODE_HOME=~/Documents/software/node-v12.14.1-linux-x64
sudo tar -Jxvf ${node_tar_xz_path} -C ~/Documents/software
echo "
# node environment
export NODE_HOME=${NODE_HOME}
export PATH=\$PATH:\$NODE_HOME/bin
" >> ~/.bashrc
source ~/.bashrc
end


begin 'Install vue and vue-cli'
npm install vue
npm install -g @vue/cli
end


begin 'Install some basic tools'
sudo apt install vim
sudo apt install git
end


begin 'Install Google Chrome'
google_chrome_deb_path=${ROOT}/packages/google-chrome-stable_current_amd64.deb
sudo dpkg -i ${google_chrome_deb_path}
end


begin 'Install Jetbrains Toolbox'
jetbrains_toolbox_tar_gz_path=${ROOT}/packages/jetbrains-toolbox-1.16.6319.tar.gz
sudo tar -zxvf ${jetbrains_toolbox_tar_gz_path} -C ~/Documents/software
end


begin 'Install Google Pinyin'
sudo apt install fcitx-bin
sudo apt install fcitx-table
sudo apt install fcitx-googlepinyin
echo "Choose fcitx in language settings and reboot! Add Google-Pinyin to input methods!"
end


printf "==========> Please, input your username "
read -r username
sudo chown -R ${username}.${username} ~/Documents/software

