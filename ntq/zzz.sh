#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

version="v1.0.0"

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Lỗi: ${plain} Kịch bản này phải được chạy bằng cách sử dụng người dùng root!\n" && exit 1

# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}Phiên bản hệ thống không được phát hiện, vui lòng liên hệ với tác giả tập lệnh!${plain}\n" && exit 1
fi

os_version=""

# os version
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi

if [[ x"${release}" == x"centos" ]]; then
    if [[ ${os_version} -le 6 ]]; then
        echo -e "${red}Vui lòng sử dụng CentOS 7 hoặc phiên bản mới hơn của hệ thống!${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [[ ${os_version} -lt 16 ]]; then
        echo -e "${red}Vui lòng sử dụng Ubuntu 16 hoặc phiên bản mới hơn của hệ thống!${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red}Vui lòng sử dụng Debian 8 hoặc phiên bản mới hơn của hệ thống!${plain}\n" && exit 1
    fi
fi

#Cài đặt Docker
install_docker(){
    echo -e "${green}Cài đặt Docker${plain}"
    if [[ x"${release}" == x"centos" ]]; then
yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io -y
systemctl start docker
systemctl enable docker
    elif [[ x"${release}" == x"ubuntu" ]]; then
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
systemctl start docker
systemctl enable docker
    else
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
systemctl start docker
systemctl enable docker
    fi
}

install_docker_compose(){
    echo -e "${green}Cài đặt Docker Compose${plain}"
curl -fsSL https://get.docker.com | bash -s docker
curl -L "https://github.com/docker/compose/releases/download/1.26.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
}
#tạo thư mục
mkdir /AikoXrayR-Dockerinstall -p
cd /AikoXrayR-Dockerinstall
Install_xrayr(){
    echo -e "${green}Cài đặt Xrayr${plain}"
git clone https://github.com/AikoXrayR-project/AikoXrayR-Dockerinstall
}

# Pre-installation settings
pre_install_docker_compose() {
#install key_path
    echo -e "[${Green}Key Hợp Lệ${plain}] Link Web : https://www.ezdigi.biz"
    read -p " ID nút (Node_ID):" node_id
    [ -z "${node_id}" ] && node_id=0
    echo "-------------------------------"
    echo -e "Node_ID: ${node_id}"
    echo "-------------------------------"

# giới hạn tốc độ
    read -p " Giới hạn tốc độ (Mbps):" limit_speed
    [ -z "${limit_speed}" ] && limit_speed=0
    echo "-------------------------------"
    echo -e "Giới hạn tốc độ: ${limit_speed}"
    echo "-------------------------------"

# giới hạn thiết bị
    read -p " Giới hạn thiết bị (Limit):" limit
    [ -z "${limit}" ] && limit=0
    echo "-------------------------------"
    echo -e "Limit: ${limit}"
    echo "-------------------------------"
}

create_docker_compose(){
    echo -e "${green}Tạo file docker-compose.yml${plain}"
    cat > /AikoXrayR-Dockerinstall/docker-compose.yml <<EOF
version: '3'
services: 
  xrayr: 
    image: aikocute/xrayr
    volumes:
      - ./config.yml:/etc/XrayR/config.yml # thư mục cấu hình bản đồ
      - ./dns.json:/etc/XrayR/dns.json 
    restart: always
    network_mode: host
EOF
}

settings_config(){
    echo -e "${green}Cài đặt cấu hình${plain}"
cat > /AikoXrayR-Dockerinstall/config/config.yml <<EOF

Log:
  Level: warning # Log level: none, error, warning, info, debug 
  AccessPath: # /etc/XrayR/access.Log
  ErrorPath: # /etc/XrayR/error.log
DnsConfigPath: # /etc/XrayR/dns.json # Path to dns config
RouteConfigPath: # /etc/XrayR/route.json # Path to route config
InboundConfigPath: # /etc/XrayR/custom_inbound.json # Path to custom inbound config
OutboundConfigPath: # /etc/XrayR/custom_outbound.json # Path to custom outbound config
  Handshake: 4 # Handshake time limit, Second
  ConnIdle: 86400 # Connection idle time limit, Second
  UplinkOnly: 2 # Time limit when the connection downstream is closed, Second
  DownlinkOnly: 4 # Time limit when the connection is closed after the uplink is closed, Second
  BufferSize: 64 # The internal cache size of each connection, kB 
Nodes:
  -
    PanelType: "V2board" # Panel type: SSpanel, V2board, PMpanel, Proxypanel
    ApiConfig:
      ApiHost: "https://ezdigi.biz"
      ApiKey: "kenhdidong_mmmzo"
      NodeID: 41
      NodeType: V2ray # Node type: V2ray, Shadowsocks, Trojan, Shadowsocks-Plugin
      Timeout: 30 # Timeout for the api request
      EnableVless: false # Enable Vless for V2ray Type
      EnableXTLS: false # Enable XTLS for V2ray and Trojan
      SpeedLimit: $limit_speed # Mbps, Local settings will replace remote settings, 0 means disable
      DeviceLimit: $limit # Local settings will replace remote settings, 0 means disable
      RuleListPath: /etc/XrayR/AikoBlock # /etc/XrayR/AikoBlock Path to local rulelist file
    ControllerConfig:
      ListenIP: 0.0.0.0 # IP address you want to listen
      SendIP: 0.0.0.0 # IP address you want to send pacakage
      UpdatePeriodic: 60 # Time to update the nodeinfo, how many sec.
      EnableDNS: false # Use custom DNS config, Please ensure that you set the dns.json well
      DNSType: AsIs # AsIs, UseIP, UseIPv4, UseIPv6, DNS strategy
      EnableProxyProtocol: false # Only works for WebSocket and TCP
      EnableFallback: false # Only support for Trojan and Vless
      FallBackConfigs:  # Support multiple fallbacks
        -
          SNI: # TLS SNI(Server Name Indication), Empty for any
          Alpn: # Alpn, Empty for any
          Path: # HTTP PATH, Empty for any
          Dest: 80 # Required, Destination of fallback
          ProxyProtocolVer: 0 # Send PROXY protocol version, 0 for dsable
      CertConfig:
        CertMode: none # Option about how to get certificate: none, file, http, dns. Choose "none" will forcedly disable the tls config.
        CertDomain: "node1.test.com" # Domain to cert
        CertFile: /etc/XrayR/cert/node1.test.com.cert # Provided if the CertMode is file
        KeyFile: /etc/XrayR/cert/node1.test.com.key
        Provider: alidns # DNS cert provider, Get the full support list 
        Email: test@me.com
        DNSEnv: # DNS ENV option used by DNS provider
          ALICLOUD_ACCESS_KEY: aaa
          ALICLOUD_SECRET_KEY: bbb
EOF
  sed -i "s|NodeID:.*|NodeID: ${node_id}|" /AikoXrayR-Dockerinstall/config.yml
  sed -i "s|DeviceLimit:.*|DeviceLimit: ${limit}|" /AikoXrayR-Dockerinstall/config.yml
  sed -i "s|SpeedLimit:.*|SpeedLimit: ${limit_speed}|" /AikoXrayR-Dockerinstall/config.yml
}

install_cert(){
    echo -e "${green}Cài đặt chứng chỉ${plain}"
    cat > /AikoXrayR-Dockerinstall/key.pem <<EOF 
-----BEGIN CERTIFICATE-----
MIIFGjCCBAKgAwIBAgISBLvBJR/BC8BuuVCYzAMriWfGMA0GCSqGSIb3DQEBCwUA
MDIxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1MZXQncyBFbmNyeXB0MQswCQYDVQQD
EwJSMzAeFw0yMjA1MjcwODAwNDJaFw0yMjA4MjUwODAwNDFaMBUxEzARBgNVBAMT
CmV6ZGlnaS5iaXowggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC0wAdB
cfA+mesMyIWo/nUBh2WuAZLJseryftWxSmXEnK3HxqHq7RZr2mWy5NzZP4XUNojT
4ZWo20d9wN9EGgG9jdaHyqD5Qsvp/J4ckBV1h9gssal7W2QCiSW0ok2MWf0OIPmi
4M7iZYhyFXqL/cc0apAhcMPxMW2xkNMOyYIvBDZlo7oX8Alo9BbFgqzckurDVOXA
dtrSzeEOTyaECKEAXSaPrkGVZASN6xWGe4Gg7LS3O9r5xkIkOvKaHgMpzKpctsVp
YhaAbibw8MyJh50NK7zdg3EXVhBG5/uR9zS4HexkClPcsZLiORfecY2S7gGKuWUd
1S6Nikd/6+Fa4SEHAgMBAAGjggJFMIICQTAOBgNVHQ8BAf8EBAMCBaAwHQYDVR0l
BBYwFAYIKwYBBQUHAwEGCCsGAQUFBwMCMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYE
FANYmyq42MxaVxmSJ7j8g2TDe8voMB8GA1UdIwQYMBaAFBQusxe3WFbLrlAJQOYf
r52LFMLGMFUGCCsGAQUFBwEBBEkwRzAhBggrBgEFBQcwAYYVaHR0cDovL3IzLm8u
bGVuY3Iub3JnMCIGCCsGAQUFBzAChhZodHRwOi8vcjMuaS5sZW5jci5vcmcvMBUG
A1UdEQQOMAyCCmV6ZGlnaS5iaXowTAYDVR0gBEUwQzAIBgZngQwBAgEwNwYLKwYB
BAGC3xMBAQEwKDAmBggrBgEFBQcCARYaaHR0cDovL2Nwcy5sZXRzZW5jcnlwdC5v
cmcwggEEBgorBgEEAdZ5AgQCBIH1BIHyAPAAdQBByMqx3yJGShDGoToJQodeTjGL
GwPr60vHaPCQYpYG9gAAAYEEvxyOAAAEAwBGMEQCICL+nK9dLSNZLbslXJKwQ/FB
z/YWFMDI6h8b+n+7dqHMAiAFS0OZLVmJX4QMldacgUEkMoG+SIC+wh1fmfZdiUY1
ogB3ACl5vvCeOTkh8FZzn2Old+W+V32cYAr4+U1dJlwlXceEAAABgQS/HGIAAAQD
AEgwRgIhALBvS4R7c397fPQPe7qvmdVmp763caAnQX1RNbkzW76PAiEArmlfKYCI
c7KHB2IPp+1O0L1BVeFSWUCgaCbFxrJbXKIwDQYJKoZIhvcNAQELBQADggEBAK7e
WANFPDXTMh5rQzEq4hj1mUFxIFd3asc0rw6Wn9Ljqbte9SnRD4h8gbWMQwABbL/f
ENHx+d+eo9uJnGyF6yNkKCXdEkf9R3NewcBCOqrEBya5LTKU8xHLJ+78W8i2J/3j
k00svo4wqAtpIzrH1S7pRZFDSlThaRgETmhh9AACXN6OKuZjR24ZcbZfnYhEfnvy
OuTf15w72Vjwzror6g6bKNSinmEBuT4aJ2F3kLxMsiOPSvSa95W+l29UuQ0AgP3z
JKMklWviSGewOgTadvWd1I/3eL4Ay8J+SZG5s0snjAjBPxedY1uKGB+bNPiPpiXD
vq6jli+0Aw991IWJPRM=
-----END CERTIFICATE-----
EOF
    cat > /AikoXrayR-Dockerinstall/key.key <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC0wAdBcfA+mesM
yIWo/nUBh2WuAZLJseryftWxSmXEnK3HxqHq7RZr2mWy5NzZP4XUNojT4ZWo20d9
wN9EGgG9jdaHyqD5Qsvp/J4ckBV1h9gssal7W2QCiSW0ok2MWf0OIPmi4M7iZYhy
FXqL/cc0apAhcMPxMW2xkNMOyYIvBDZlo7oX8Alo9BbFgqzckurDVOXAdtrSzeEO
TyaECKEAXSaPrkGVZASN6xWGe4Gg7LS3O9r5xkIkOvKaHgMpzKpctsVpYhaAbibw
8MyJh50NK7zdg3EXVhBG5/uR9zS4HexkClPcsZLiORfecY2S7gGKuWUd1S6Nikd/
6+Fa4SEHAgMBAAECggEAG2yNTUUzzdO9oYVlHjRpXU+FQmbztg18F8nds1YV5cRd
65M8KvBI+Bk9V+y4g2/LZtzVWsx90A5hJPfYCDWn8PItzBGW5erYFIrjFHNaBiiT
yIg2LkS6AlZ7tZHwkSxwJC4loixYx2nfT2vp2YaqLE5EywYYfKZivc+67iHt0iMg
jvZcgSJ39j2EcA0At5WZG89fwsC++WG7Hs7I/kBfpi7msvlkN3rdvBdprR/P3VS6
pPfddvOKgipKwrTBlA27IX35Sx6RhrhABHYmwBvLzZ7Zx2CLfLG201oGpph1o0ee
nrC1gVybb+0JHDWYITei3kXWLgQ8UDYYQrWh3e+3FQKBgQDJBq/XWV5OK9GymOfY
mAAxetM7D8KhJLG2wItqint0jnNG2jsRA77yzoNcMBy+3BnzmZHPXFKHgCFLNjG0
HlXgjjUGXaY7iCAdKwbDUK8eEk3nCUruMXCI0e1HjLCr/7BQZOjwYpAfP5VSckvU
Eo0VK3MteR1EiUkHZgMoWaQELQKBgQDmLd77M+Rb5eItc1RBA7MHg1+7f685j5v3
Nf232sa0U/uxWCv8WPoWk3d8dhbARJHgXaQ3O4q70etdjWlVk369KO9gP6cw3Ly5
hOB3VCXF9ltsmfabP0EAkyTZNPC+gmhViUJdDUAOK+2Yab9t3bzYZWIw5uLtIhij
PTjDase2gwKBgQCU6uw2ZpDS7ekhGd6eeDOkc+2o0gsHXux7inV9DmtYM/K3qRCa
kSDSNCPhlg6lYN2ktL3sU+MbV9LSKap2WQabHB2xwoxTi4rmsKoI5Gtlpn+pSBwH
Cf7ojELvfwydzgMp+ycIdKt5SpvugJcl2jxDU3W2WQNSczTzUyHBsW4sXQKBgBoT
/lxVf7zNqbdehqArDCCAyNrUV4Tc+V2jt1AaMEMD9NMd2zXm2sauBG6Mbn1wB1r1
IQLE8y3eVZ0uxU1VvZkuxxgPfiCyEYuvO0MpvHHWPHtsYh0qqHGpOhaFwfTDj5CJ
UYR7WNOCNJP8/xwycA/QRLSno/Qb1dDAweqZ8XCDAoGAaAQa5mfRL65kYaYVcACB
MVlS6s+7yMrFbA+p4KBumYtsFbL8RJmISVLyGHmm096k2Xj6oOhoHz62rie38gGt
3qo5HRabiCiV7u8N6xnxO2vTPlNkgPjA/ekDfo/9F9pzS/ABOvKU6xodxKJ/QZOX
2i09ueIyqerGG5AsCnPfVLw=
-----END PRIVATE KEY-----
EOF
}

update-xrayr(){
    echo "Update XrayR"
    cd /AikoXrayR-Dockerinstall
    docker-compose up -d
}

install_and_update(){
    docker-compose up -d
}

install_xrayr_vmess(){
    echo -e "Installing xrayr vmess..."
    install_docker
    install_docker_compose
    create_docker_compose
    pre_install_docker_compose && settings_config
    install_and_update
}

install_xrayr_trojan(){
    echo -e " Sẽ sớm ra mắt ... "
}

install_xrayr_vmess_trojan(){
    echo -e " Comming Soon .... "
}

install_bbr(){
   bash <(curl -L -s https://raw.githubusercontent.com/AikoCute/BBR/aiko/tcp.sh)
}

install_xrayr(){
    echo -e "[1] Vmess"
    echo -e "[2] Trojan "
    echo -e "[3] Vmess + Trojan"
    read -p "vui lòng chọn：" install_type
    if [ $install_type == 1 ]; then
        install_xrayr_vmess
        show_menu
    elif [ $install_type == 2 ]; then
        install_xrayr_trojan
        show_menu
    elif [ $install_type == 3 ]; then
        install_xrayr_vmess_trojan
        show_menu
    else
        echo -e "không hỗ trợ"
        show_menu
    fi
}

show_menu() {
    echo -e "
  ${green}AikoXrayR - Hoạt động với docker${plain}
--- https://github.com/AikoCute/Xray/ ---
  ${green}0.${plain} Thoát
————————————————
  ${green}1.${plain} Cài đặt XrayR
  ${green}2.${plain} Update XrayR
  ${green}3.${plain} Chưa biết cài gì
————————————————
  ${green}4.${plain} Cài dặt Chứng chỉ SSL
  ${green}5.${plain} Cài đặt BBR

 "

     echo && read -p "Vui lòng nhập một lựa chọn [0-14]: " num

    case "${num}" in
        0) exit 0
        ;;
        1) install_xrayr
        ;;
        2) update-xrayr
        ;;
        3) echo -e "Comming Soon"
        ;;
        4) install_cert
        ;;
        *) echo -e "${red}Vui lòng nhập số chính xác [0-4]${plain}"
        ;;
    esac
}

show_menu
