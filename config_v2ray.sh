#!/bin/bash
read -p "Vui lòng nhập node ID :" aiko_node_id
      [ -z "${aiko_node_id}" ]
      echo -e "${green}Node ID của bạn đặt là: ${aiko_node_id}${plain}"
      echo -e "-------------------------"

      wget https://raw.githubusercontent.com/zzzzzzzzzzzzzzzmga/coca/main/config/Config-V2ray.yml -O /etc/XrayR/aiko.yml
      wget https://raw.githubusercontent.com/AikoXrayR-Project/AikoXrayR-DockerInstall-Beta/main/config/AikoBlock -O /etc/XrayR/AikoBlock
      sed -i "s/NodeID:.*/NodeID: ${aiko_node_id}/g" /etc/XrayR/aiko.yml
