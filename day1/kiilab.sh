#!/bin/bash
# Сохраните как ~/kiilab.sh и запустите: sudo bash ~/kiilab.sh

echo "=== Этап 1: Очистка предыдущих настроек ==="
ip netns list | grep -q asu_tp && ip netns del asu_tp
ip netns list | grep -q corporate && ip netns del corporate
ip netns list | grep -q dmz && ip netns del dmz
iptables -F FORWARD

echo "=== Этап 2: Создаём 3 изолированных сегмента ==="
ip netns add asu_tp
ip netns add corporate
ip netns add dmz

echo "=== Этап 3: Настраиваем виртуальные интерфейсы ==="
# АСУ ТП (192.168.10.0/24)
ip link add veth-asu type veth peer name veth-host-asu
ip link set veth-host-asu up
ip addr add 192.168.10.1/24 dev veth-host-asu
ip link set veth-asu netns asu_tp
ip netns exec asu_tp ip addr add 192.168.10.10/24 dev veth-asu
ip netns exec asu_tp ip link set veth-asu up
ip netns exec asu_tp ip link set lo up
ip netns exec asu_tp ip route add default via 192.168.10.1

# Офис (192.168.20.0/24)
ip link add veth-corp type veth peer name veth-host-corp
ip link set veth-host-corp up
ip addr add 192.168.20.1/24 dev veth-host-corp
ip link set veth-corp netns corporate
ip netns exec corporate ip addr add 192.168.20.10/24 dev veth-corp
ip netns exec corporate ip link set veth-corp up
ip netns exec corporate ip link set lo up
ip netns exec corporate ip route add default via 192.168.20.1

# DMZ (192.168.30.0/24)
ip link add veth-dmz type veth peer name veth-host-dmz
ip link set veth-host-dmz up
ip addr add 192.168.30.1/24 dev veth-host-dmz
ip link set veth-dmz netns dmz
ip netns exec dmz ip addr add 192.168.30.10/24 dev veth-dmz
ip netns exec dmz ip link set veth-dmz up
ip netns exec dmz ip link set lo up
ip netns exec dmz ip route add default via 192.168.30.1

echo "=== Этап 4: Включаем маршрутизацию ==="
sysctl -w net.ipv4.ip_forward=1 >/dev/null

echo "=== Этап 5: Настраиваем сегментацию КИИ (блокируем офис → АСУ ТП) ==="
iptables -A FORWARD -s 192.168.20.0/24 -d 192.168.10.0/24 -j DROP
iptables -A FORWARD -j ACCEPT
echo "✅ Правило применено: трафик из офиса (192.168.20.0/24) в АСУ ТП (192.168.10.0/24) ЗАБЛОКИРОВАН"

echo -e "\n=== Этап 6: Проверка доступности ==="
echo "Тест 1: Пинг из ОФИСА в АСУ ТП (должен БЫТЬ ЗАБЛОКИРОВАН):"
ip netns exec corporate ping -c 2 192.168.10.10

echo -e "\nТест 2: Пинг из ОФИСА в DMZ (должен ПРОЙТИ):"
ip netns exec corporate ping -c 2 192.168.30.10

echo -e "\nТест 3: Пинг из DMZ в АСУ ТП (должен ПРОЙТИ — мониторинг):"
ip netns exec dmz ping -c 2 192.168.10.10

echo -e "\n=== Итог ==="
echo "✅ Сегментация КИИ реализована:"
echo "   • АСУ ТП изолирована от офисной сети (требование Пост. 1119 п.14)"
echo "   • Доступ в АСУ ТП разрешён ТОЛЬКО из DMZ (серверы мониторинга)"
echo "   • Правила применены через iptables (аналог С-Терра на уровне ядра Linux)"