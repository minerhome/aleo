#!/bin/bash

[[ $(id -u) != 0 ]] && echo -e "请使用root权限运行安装脚本， 通过sudo su root切换再来运行" && exit 1

name = "鱼池 aleo 安装"


cmd="apt-get"
if [[ $(command -v apt-get) || $(command -v yum) ]] && [[ $(command -v systemctl) ]]; then
    if [[ $(command -v yum) ]]; then
        cmd="yum"
    fi
else
    echo "此脚本不支持该系统" && exit 1
fi


pid=`ps -ef | grep "mh_tunnel" |  awk '{print $2}'`
if [ -n "$pid" ]
then
	echo "kill running mh_tunnel $pid"
	kill -9 $pid
fi



check_done() {

    pid=`ps -ef | grep "12510" |  awk '{print $2}'`
    if [ -n "$pid" ]
    then
        echo -e "\n\n" 
        echo -e "--------------------------------------------------------"
        echo -e "\n" 
        echo -e "安装成功， 端对端加密隧道流量混淆转发 - 加密端（本地端）- 已经在运行......" 
        echo -e "详细用法请上 https://minerhome.org 网站查阅\n" 
        echo -e "\n" 
        echo -e "--------------------------------------------------------"
        echo -e "\n" 
    else        
        echo -e "\n\n" 
        echo "安装不成功，请重启后重新安装"   
        echo "出现各种选择，请按 确认/OK"
        echo -e "\n\n" 
    fi    


}


inst_driver(){
    echo "正在安装显卡驱动"
    $cmd install build-essential  -y
    $cmd  install ubuntu-drivers-common  -y
    $cmd install nvidia-driver-515-server  -y
}


inst_cuda(){
    echo "正在安装cuda"
    wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda_11.7.1_515.65.01_linux.run
    sudo sh cuda_11.7.1_515.65.01_linux.run
}

inst_tunnel(){
    echo "正在安装加密隧道"
    rm -rf /etc/rc.local
    rm -rf /root/mh_tunnel
    mkdir /root/mh_tunnel  

    wget  --no-check-certificate  https://raw.githubusercontent.com/minerhome/mh_tunnel/main/scripts/tunnel/pools.txt  -O  /root/mh_tunnel/pools.txt
    wget  --no-check-certificate  https://raw.githubusercontent.com/minerhome/mh_tunnel/main/scripts/tunnel/httpsites.txt  -O  /root/mh_tunnel/httpsites.txt
    wget  --no-check-certificate  https://raw.githubusercontent.com/minerhome/mh_tunnel/main/scripts/tunnel/run_mh_tunnel.sh  -O  /root/mh_tunnel/run_mh_tunnel.sh
    wget  --no-check-certificate  https://raw.githubusercontent.com/minerhome/mh_tunnel/main/scripts/tunnel/mh_tunnel.service  -O  /lib/systemd/system/mh_tunnel.service
    wget  --no-check-certificate https://raw.githubusercontent.com/minerhome/mh_tunnel/main/releases/mh_tunnel/v7.0.0/mh_tunnel  -O  /root/mh_tunnel/mh_tunnel

    chmod +x /root/mh_tunnel/*
    systemctl daemon-reload
    systemctl enable mh_tunnel  >> /dev/null
    systemctl restart mh_tunnel  &    
}



install() {
    
    # ufw disable
    # $cmd update -y

    $cmd install curl -y
    $cmd install wget -y
    $cmd install net-tools -y
    
    inst_driver
    inst_cuda    

    inst_tunnel

    mkdir /aleo  

    wget  --no-check-certificate  https://raw.githubusercontent.com/minerhome/aleo/main/data/f2pool/aleo.sh   -O  /aleo/aleo.sh
    wget  --no-check-certificate  https://raw.githubusercontent.com/minerhome/aleo/main/data/f2pool/inst.sh   -O  /aleo/inst.sh
    wget  --no-check-certificate  https://raw.githubusercontent.com/minerhome/aleo/main/data/f2pool/mh_aleo.service   -O  /lib/systemd/system/mh_aleo.service
    wget  --no-check-certificate  https://raw.githubusercontent.com/minerhome/aleo/main/data/f2pool/aleo-prover-cuda   -O  /aleo/aleo-prover-cuda
    
    chmod +x /aleo/*
    systemctl daemon-reload
    systemctl enable mh_aleo  >> /dev/null
    systemctl restart mh_aleo  &   
}


uninstall() {    
        clear
        echo -e "\n" 
        echo -e "\n" 
        echo -e "\n" 
        echo -e "\n" 
        echo -e "\n" 
        echo "正在卸载aleo挖矿软件......"
        systemctl stop mh_aleol  &
        systemctl disable mh_aleo  >> /dev/null
        rm -rf /aleo
        rm -rf /lib/systemd/system/mh_aleo.service
        echo "卸载完记得重启"
}



setup_cn() {
    cd /root/mh_tunnel   
    ./mh_tunnel --setup
    # wget  --no-check-certificate   https://cdn.jsdelivr.net/gh/minerhome/mh_tunnel@master/scripts/tunnel/mh_setup  -O /root/mh_tunnel/mh_setup
    # chmod +x /root/mh_tunnel/*
    # ./mh_setup
}



setup() {
    cd /root/mh_tunnel   
    ./mh_tunnel --setup
#     wget  --no-check-certificate  https://raw.githubusercontent.com/minerhome/mh_tunnel/main/scripts/tunnel/mh_setup  -O /root/mh_tunnel/mh_setup
#     chmod +x /root/mh_tunnel/*
#     ./mh_setup
}




clear
echo -e "\n" 
echo -e "\n" 
echo -e "\n" 
echo -e "\n" 
echo -e "\n" 
echo "========================================================================================="
echo "安装aleo挖矿软件  鱼池 以后会增加其它池 - 矿工之家 - https://minerhome.org"
echo "默认安装到 /aleo"
echo "安装完成后请自己修改你的挖矿帐号"
echo "如果安装不成功，则重启服务器后重新安装"
echo "出现各种选择，请按 确认/OK"
echo "  1、安装(默认安装到/aleo) - 安装完记得重启服务器 - 软件开机会自动启动，后台守护运行"
echo "  2、卸载 - 删除本软件"
echo "  3、重启电脑"
echo "========================================================================================="
read -p "$(echo -e "请选择[1-4]：")" choose
case $choose in
1)
    install
    ;;
2)
    uninstall
    ;;    
3)
    reboot
    ;;
*)
    echo "输入错误请重新输入！"
    ;;
esac


