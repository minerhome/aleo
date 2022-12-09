## aleo 鱼池 挖矿
# 安装说明
# 先要把实体机 ubuntu server安装好
# 自动安装加密隧道以及安装鱼池的挖矿软件, 安装在/root/aleo目录下
# 查看安装驱动, cuda成功
```nvidia-smi```

# 查看挖矿情况 
```tail -f /root/aleo/prover.log```



# 一键安装 通过github安装
# 安装过程中, 出现 Abort Continue时可以选择Abort
```bash <(curl -s -L  https://raw.githubusercontent.com/minerhome/aleo/main/scripts/f2pool/inst.sh)```

# 如果上面无法安装则使用这个
```bash <(curl -s -L down.minerhome.org/aleo/scripts/f2pool/inst_cn.sh)```

