#!/bin/bash

# -----------------------------------------------
# USB Pendrive Formatter v3.0 - Linux Edition
# Author : HackerG3121
# -----------------------------------------------

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

clear

# -----------------------------------------------
# STEP 1 - Scan Disks
# -----------------------------------------------

echo ""
echo -e "${GREEN} +--------------------------------------------------+"
echo -e " *        USB PENDRIVE FORMATTER  v3.0             *"
echo -e " +--------------------------------------------------+${NC}"
echo ""
echo -e "   Scanning connected disks..."
echo ""
echo -e "${GREEN} +--------+----------+----------------------------+"
echo -e " *  Disk  *   Size   *   Model / Name             *"
echo -e " +--------+----------+----------------------------+${NC}"

DISKCOUNT=0
declare -a DISK_LIST

# Read all block devices (disks only, not partitions)
while IFS= read -r line; do
    NAME=$(echo "$line" | awk '{print $1}')
    SIZE=$(echo "$line" | awk '{print $2}')
    MODEL=$(echo "$line" | awk '{$1=$2=""; print $0}' | xargs | cut -c1-26)
    INDEX=$DISKCOUNT

    DISK_LIST+=("$NAME|$SIZE|$MODEL")

    printf "${GREEN} *  %-5s  *  %-7s  *  %-26s *\n${NC}" "$INDEX" "$SIZE" "$MODEL"
    DISKCOUNT=$((DISKCOUNT + 1))

done < <(lsblk -d -o NAME,SIZE,MODEL --noheadings 2>/dev/null | grep -v "^loop")

echo -e "${GREEN} +--------+----------+----------------------------+${NC}"
echo ""
echo -e "   Total Disks Found : ${WHITE}$DISKCOUNT${NC}"
echo ""
echo -e "${YELLOW} +--------------------------------------------------+"
echo -e " *  WARNING : Formatting will ERASE ALL DATA       *"
echo -e " +--------------------------------------------------+${NC}"
echo ""
read -rp "   Enter Disk Number to Format  >>  " DISKNUM

# -----------------------------------------------
# Validate - numbers only
# -----------------------------------------------
if ! [[ "$DISKNUM" =~ ^[0-9]+$ ]]; then
    echo ""
    echo -e "${RED}  [ERROR] Invalid input. Enter a number only.${NC}"
    echo ""
    exit 1
fi

# Check if number is within range
if [ "$DISKNUM" -ge "$DISKCOUNT" ]; then
    echo ""
    echo -e "${RED}  [ERROR] Disk $DISKNUM not found. Valid range: 0 to $((DISKCOUNT-1))${NC}"
    echo ""
    exit 1
fi

# Get selected disk info
SELINFO="${DISK_LIST[$DISKNUM]}"
SELNAME=$(echo "$SELINFO" | cut -d'|' -f1)
SELSIZE=$(echo "$SELINFO" | cut -d'|' -f2)
SELMDL=$(echo "$SELINFO"  | cut -d'|' -f3)
SELDEV="/dev/$SELNAME"

# -----------------------------------------------
# STEP 2 - Confirm Screen
# -----------------------------------------------
clear
echo ""
echo -e "${GREEN} +--------------------------------------------------+"
echo -e " *               CONFIRM FORMAT                    *"
echo -e " +--------------------------------------------------+${NC}"
echo ""
echo -e "   Disk Number  :  ${WHITE}$DISKNUM${NC}"
echo -e "   Device       :  ${WHITE}$SELDEV${NC}"
echo -e "   Model        :  ${WHITE}$SELMDL${NC}"
echo -e "   Size         :  ${WHITE}$SELSIZE${NC}"
echo -e "   Format As    :  ${WHITE}FAT32${NC}"
echo -e "   Label        :  ${WHITE}USBDRIVE${NC}"
echo ""
echo -e "${RED} +--------------------------------------------------+"
echo -e " *    !!  ALL DATA WILL BE PERMANENTLY DELETED  !! *"
echo -e " *    !!      THIS ACTION CANNOT BE UNDONE      !! *"
echo -e " +--------------------------------------------------+${NC}"
echo ""
echo -e "   Press ${WHITE}ENTER${NC} to confirm format..."
echo -e "   Press ${WHITE}Ctrl+C${NC} to cancel."
echo ""
read -r  # Wait for Enter key

# -----------------------------------------------
# STEP 3 - Format
# -----------------------------------------------
clear
echo ""
echo -e "${GREEN} +--------------------------------------------------+"
echo -e " *           FORMATTING IN PROGRESS                *"
echo -e " +--------------------------------------------------+${NC}"
echo ""
echo -e "   Disk    :  ${WHITE}$DISKNUM${NC}"
echo -e "   Device  :  ${WHITE}$SELDEV${NC}"
echo -e "   Model   :  ${WHITE}$SELMDL${NC}"
echo -e "   Size    :  ${WHITE}$SELSIZE${NC}"
echo -e "   Format  :  ${WHITE}FAT32 Quick${NC}"
echo ""
echo -e "   Please wait. Do ${RED}NOT${NC} remove the drive..."
echo ""

# Unmount if mounted
umount "$SELDEV"* 2>/dev/null

# Wipe existing partition table
wipefs -a "$SELDEV" > /dev/null 2>&1

# Create new partition table and FAT32 partition
parted -s "$SELDEV" mklabel msdos > /dev/null 2>&1
parted -s "$SELDEV" mkpart primary fat32 1MiB 100% > /dev/null 2>&1

# Wait for partition to appear
sleep 1

# Detect partition name (e.g. sdb1 or sdb)
PARTITION=$(lsblk -ln -o NAME "$SELDEV" | grep -v "^$SELNAME$" | head -1)
if [ -z "$PARTITION" ]; then
    PARTDEV="${SELDEV}1"
else
    PARTDEV="/dev/$PARTITION"
fi

# Format as FAT32
mkfs.fat -F 32 -n "USBDRIVE" "$PARTDEV" > /dev/null 2>&1

RESULT=$?

# -----------------------------------------------
# STEP 4 - Done
# -----------------------------------------------
clear
echo ""
if [ $RESULT -eq 0 ]; then
    echo -e "${GREEN} +--------------------------------------------------+"
    echo -e " *           FORMAT COMPLETED                      *"
    echo -e " +--------------------------------------------------+${NC}"
    echo ""
    echo -e "   Disk     :  ${WHITE}$DISKNUM${NC}"
    echo -e "   Device   :  ${WHITE}$SELDEV${NC}"
    echo -e "   Model    :  ${WHITE}$SELMDL${NC}"
    echo -e "   Size     :  ${WHITE}$SELSIZE${NC}"
    echo -e "   Format   :  ${WHITE}FAT32${NC}"
    echo -e "   Label    :  ${WHITE}USBDRIVE${NC}"
    echo ""
    echo -e "   ${GREEN}Your pendrive is ready to use!${NC}"
else
    echo -e "${RED} +--------------------------------------------------+"
    echo -e " *           FORMAT FAILED                         *"
    echo -e " +--------------------------------------------------+${NC}"
    echo ""
    echo -e "   ${RED}Something went wrong. Try running as root (sudo).${NC}"
fi

echo ""
echo -e "${GREEN} +--------------------------------------------------+${NC}"
echo ""
read -rp "   Press Enter to exit..." 
