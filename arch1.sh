#!/bin/bash

# Arch Linux Fast Install - Быстрая установка Arch Linux https://github.com/ordanax/arch2018
# Цель скрипта - быстрое развертывание системы с вашими персональными настройками (конфиг XFCE, темы, программы и т.д.).

# В разработке принимали участие:
# Алексей Бойко https://vk.com/ordanax
# Степан Скрябин https://vk.com/zurg3
# Михаил Сарвилин https://vk.com/michael170707
# Данил Антошкин https://vk.com/danil.antoshkin
# Юрий Порунцов https://vk.com/poruncov

loadkeys ru
setfont cyr-sun16
echo 'Скрипт сделан на основе чеклиста Бойко Алексея по Установке ArchLinux'
echo 'Ссылка на чек лист есть в группе vk.com/arch4u'

echo '2.3 Синхронизация системных часов'
timedatectl set-ntp true

echo 'Ваша разметка диска'
fdisk -l

pacman -Sy
pacman -S btrfs-progs --noconfirm

echo '2.4.2 Форматирование дисков'
mkfs.btrfs  /dev/sda1
mkfs.btrfs  /dev/sdb1`

echo 'Создаем подтома:'
mount /dev/sda1 /mnt
btrfs subvolume create /mnt/sv_root
btrfs subvolume create /mnt/sv_snapshots_root
umount /mnt
mount /dev/sdb1 /mnt
btrfs subvolume create /mnt/sv_home
btrfs subvolume create /mnt/sv_snapshots_home
umount /mnt


echo '2.4.3 Монтирование дисков'
mount -o subvol=sv_root,compress=lzo,autodefrag /dev/sda1 /mnt
mkdir /mnt/home
mount -o subvol=sv_home,compress=lzo,autodefrag /dev/sdb1 /mnt/home\
mkdir /mnt/snapshots
mount -o subvol=sv_snapshots_root,compress=lzo,autodefrag /dev/sda1 /mnt/snapshots

echo '3.1 Выбор зеркал для загрузки. Ставим зеркало от Яндекс'
echo "Server = http://mirror.yandex.ru/archlinux/\$repo/os/\$arch" > /etc/pacman.d/mirrorlist

echo '3.2 Установка основных пакетов'
pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl

echo '3.3 Настройка системы'
genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -L git.io/JtTvj > arch2.sh)"
