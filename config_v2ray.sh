#!/bin/bash
read -p "Vui lòng nhập node ID :" aiko_node_id
      [ -z "${aiko_node_id}" ]
      echo -e "${green}Node ID của bạn đặt là: ${aiko_node_id}${plain}"
      echo -e "-------------------------"

      wget https://raw.githubusercontent.com/zzzzzzzzzzzzzzzmga/coca/main/config/Config-V2ray.yml -O /etc/XrayR/aiko.yml
      wget https://raw.githubusercontent.com/ezDiGi/keypem/main/AikoBlock -O /etc/XrayR/AikoBlock
      wget https://raw.githubusercontent.com/zzzzzzzzzzzzzzzmga/coca/main/docker-compose.yml -O /etc/XrayR/docker-compose.yml
      sed -i "s/NodeID:.*/NodeID: ${aiko_node_id}/g" /etc/XrayR/aiko.yml
