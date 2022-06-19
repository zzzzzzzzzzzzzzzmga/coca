#!/bin/bash
echo -e "[1] Mở Port"
echo -e "[2] Check trạng thái cổng"
read -p "Vui lòng chọn: " choose_unlock_port

if [ "$choose_unlock_port" == "1" ]; then
    read -p "Vui lòng nhập port cần mở: " port_unlock
    if [ "$release" == "ubuntu" ]; then
        ufw enable
        ufw allow $port_unlock/tcp
        ufw allow $port_unlock/udp
        ufw reload
    elif [ "$release" == "debian" ]; then
        iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport $port_unlock -j ACCEPT
        iptables -A INPUT -m state --state NEW -m udp -p udp --dport $port_unlock -j ACCEPT
        /etc/init.d/iptables save
        /etc/init.d/iptables restart
    elif [ "$release" == "centos" ]; then
        systemctl start firewalld
        firewall-cmd --zone=public --add-port=$port_unlock/tcp --permanent
        firewall-cmd --zone=public --add-port=$port_unlock/udp --permanent
        firewall-cmd --reload
    fi
    echo -e "Port $port_unlock đã được mở"
    echo -e "Nhấn [Enter] để tiếp tục"
    read -p ""
elif [ "$choose_unlock_port" == "2" ]; then
    if [ "$release" == "ubuntu" ]; then
        ufw status
        echo -e "Nhấn [Enter] để tiếp tục"
        read -p ""
    elif [ "$release" == "debian" ]; then
        iptables -L
        echo -e "Nhấn [Enter] để tiếp tục"
        read -p ""
    elif [ "$release" == "centos" ]; then
        firewall-cmd --list-all
        echo -e "Nhấn [Enter] để tiếp tục"
        read -p ""
    else
        echo -e "Nhấn [Enter] để tiếp tục"
        read -p ""
    fi
else
    echo -e "${red}Bạn đã chọn sai, vui lòng chọn lại [1-2]${plain}"