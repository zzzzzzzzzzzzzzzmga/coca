#!/bin/bash
pre_install_docker_compose() {
read -p "  ID nút (Node_ID):" node_id
  [ -z "${node_id}" ] && node_id=0
  echo "-------------------------------"
  echo -e "  Node_ID: ${node_id}"
  echo "-------------------------------"

  # giới hạn thiết bị
read -p "  Giới hạn thiết bị :" DeviceLimit
  [ -z "${DeviceLimit}" ] && DeviceLimit="0"
  echo "-------------------------------"
  echo "  Thiết bị tối đa là: ${DeviceLimit}"
  echo "-------------------------------"

      wget https://raw.githubusercontent.com/zzzzzzzzzzzzzzzmga/coca/main/config/Config-V2ray.yml -O /etc/XrayR/aiko.yml
      wget https://raw.githubusercontent.com/ezDiGi/keypem/main/AikoBlock -O /etc/XrayR/AikoBlock
      wget https://raw.githubusercontent.com/zzzzzzzzzzzzzzzmga/coca/main/docker-compose.yml -O /etc/XrayR/docker-compose.yml
      sed -i "s|NodeID:.*|NodeID: ${node_id}|" ./etc/XrayR/aiko.yml
      sed -i "s|DeviceLimit:.*|DeviceLimit: ${limit}|" /etc/XrayR/aiko.yml
      sed -i "s|SpeedLimit:.*|SpeedLimit: ${limit_speed}|" /etc/XrayR/aiko.yml
