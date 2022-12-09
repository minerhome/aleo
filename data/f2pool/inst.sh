#!/bin/bash


echo "正在安装 aleo-鱼池 守护程序"
cp /aleo/mh_aleo.service  /lib/systemd/system/
systemctl enable mh_aleo
systemctl daemon-reload
systemctl restart  mh_aleo

