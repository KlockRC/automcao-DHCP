#!/bin/bash
#
#
# automaçao DHCP
# Ruan Cesar

# variaveis
pasta="/etc/dhcp"
arq="dhcpd.conf"
tudo="/etc/dhcp/dhcpd.conf"
tudo1="/etc/network/interfaces"

shopt -s -o nounset

echo "instalaçao do dhcp com configuraçao automatica"

# verificando privilegios
if sudo -n true 2>/dev/null; then
    echo "O usuário tem privilégios sudo."
    sleep 2
else
    echo " pfv tenha permiçao sudo para executar esse script"
    echo "saindo..... "
    sleep 3
    exit 1
fi

# atualizando o sistema
echo "atualizando o sistema"
sleep 2
apt-get update -y && apt-get upgrade -y
sleep 4

# verificando a instalaçao do programa

if [ comand -v isc-dhcp-server &>/dev/null ]; then
    echo " o programa ja esta instalado "
    echo "saindo...."
    exit 1
else
    echo " instalando o dhcp "
    sleep 2
fi

#instalando o programa
apt-get install isc-dhcp-server -y
sleep 4

echo "iniciando configuraçao"

echo "qual o nome de dominio?"
read domain
echo "qual o ip do servidor dns?"
read dns
echo "qual o ip da rede?"
read rede
echo "qual é a mask?"
read mask
echo "qual o primeiro range?"
read range
echo "qual é o segundo range?"
read range1
echo "qual é gateway?"
read gateway
echo "qual é o tempo de expiraçao do ip ?(em segundos)"
read time
echo "qual é o ip do seu servidor?"
read ip
echo "chega de perguntas só aproveite o tempo livre :)"
sleep 2

#configuraçao do arquivo dhcpd.conf

rm -f $pasta/$arq
touch $pasta/$arq
echo option domain-name \"$domain\"\; >> $tudo
echo "option domain-name-servers $dns;" >> $tudo
echo "default-lease-time $time;" >> $tudo
echo "authoritative;" >> $tudo
echo "subnet $rede netmask $mask {" >> $tudo
echo "          " >> $tudo
echo "  range $range $range1;" >> $tudo
echo "  option subnet-mask $mask;" >> $tudo
echo "  option routers $gateway;" >> $tudo
echo "          " >> $tudo
echo "}" >> $tudo

#configuraçao de ip da maquina

echo "source /etc/network/interface.d/*" > $tudo1
echo "auto lo" >>$tudo1
echo "iface lo inet loopback" >>$tudo1
echo "allow-hotplug enp0s3" >>$tudo1
echo "iface enp0s3 inet static" >>$tudo1
echo "address $ip" >>$tudo1
echo "netmask $mask" >>$tudo1
echo "gateway $gateway" >>$tudo1
/etc/init.d/networking restart


rm -f $0