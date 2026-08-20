function nrs
  set hostname (string replace -r "^:" "#" -- $argv[1])
  bash -c "sudo nixos-rebuild switch --flake /home/grae/nixos$hostname |& nom"
end

function qmk-swap
  if test "$argv[1]" = --new
    if not command -v qmk >/dev/null
      echo "qmk is not installed yet. Add it to dev-tools.nix and rebuild first."
      return 1
    end
    qmk c2json -kb silakka54 -km default > silakka54-keymap.json
    and echo "Wrote silakka54-keymap.json from the stock keymap. Edit the 'layers' arrays, then run: qmk-swap silakka54-keymap.json"
    or echo "Failed to generate the template. Is qmk_firmware set up? Run: qmk setup"
    return
  end

  if test (count $argv) -ne 1
    echo "Usage: qmk-swap <keymap.json>"
    echo "       qmk-swap --new   (generate a starter silakka54 keymap.json)"
    return 1
  end

  set -l file $argv[1]
  if not test -f "$file"
    echo "File not found: $file"
    return 1
  end

  if not command -v qmk >/dev/null
    echo "qmk is not installed yet. Add it to dev-tools.nix and run: sudo nixos-rebuild switch --flake /home/grae/nixos#<host>"
    return 1
  end

  set -l qmk_home (qmk config user.qmk_home 2>/dev/null | string replace -r '^user\.qmk_home=' '')
  test -z "$qmk_home"; and set qmk_home "$HOME/qmk_firmware"
  if not test -d "$qmk_home"
    echo "qmk_firmware is not set up yet. Run: qmk setup"
    echo "(This clones qmk_firmware to $qmk_home and checks the build toolchain.)"
    return 1
  end

  echo "Compiling $file..."
  if not qmk compile "$file"
    echo "Compile failed. Fix the errors above (or run: qmk doctor -n)."
    return 1
  end

  set -l uf2 (ls -t "$qmk_home"/.build/*.uf2 2>/dev/null | head -n 1)
  if test -z "$uf2"
    echo "No .uf2 firmware was produced in $qmk_home/.build — something went wrong."
    return 1
  end
  echo "Built: $uf2"

  for side in LEFT RIGHT
    set -l mount ""
    echo ""
    echo "=== Flashing $side half ==="
    while test -z "$mount"
      echo "1. Unplug the keyboard from USB."
      echo "2. On the $side half, HOLD the BOOT button on the RP2040 Zero."
      echo "3. Plug the USB cable into that half while holding BOOT, then release."
      echo "   It should show up as a 'RPI-RP2' USB drive."
      read -p "echo 'Press Enter when the drive is visible (or type abort): '" confirm
      if test "$confirm" = abort
        echo "Aborted."
        return 1
      end
      for i in (seq 1 15)
        set -l m (lsblk -rno LABEL,MOUNTPOINT 2>/dev/null | string match -r '^RPI-RP2[ \t]+(.+)$')
        if test -n "$m[2]" -a -d "$m[2]"
          set mount "$m[2]"
          break
        end
        sleep 1
      end
      if test -z "$mount"
        echo "Could not find the RPI-RP2 drive. Try again (hold BOOT while plugging in)."
      end
    end
    echo "Found: $mount"
    echo "Copying firmware..."
    cp "$uf2" "$mount/"
    sync
    for i in (seq 1 15)
      test -d "$mount"; or break
      sleep 1
    end
    echo "$side half flashed."
  end

  echo ""
  echo "Done! Both halves should now run the new layout."
  echo "If keys are swapped/missing, check handedness: the half plugged into USB is the left side by default."
end

function iso2sd
  if test (count $argv) -lt 1
    echo "Usage: iso2sd <input_file> [output_device]"
    echo "Example: iso2sd ~/Downloads/ubuntu.iso /dev/sda"
    echo ""
    echo "Available drives:"
    lsblk -dpno NAME | grep -E '/dev/sd'; or true
    return 1
  end
  set iso $argv[1]
  set drive $argv[2]
  if test -z "$drive"
    set available (lsblk -dpno NAME | grep -E '/dev/sd')
    if test -z "$available"
      echo "No SD drives found and no drive specified"
      return 1
    end
    echo "Available drives: $available"
    read -p "echo 'Enter drive: '" drive
  end
  sudo dd bs=4M status=progress oflag=sync if=$iso of=$drive
  and sudo eject $drive
end

function format-drive
  if test (count $argv) -ne 2
    echo "Usage: format-drive <device> <name>"
    echo "Example: format-drive /dev/sda 'My Stuff'"
    echo ""
    echo "Available drives:"
    lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
    return 1
  end
  echo "WARNING: This will completely erase all data on $argv[1] and label it '$argv[2]'."
  read -p "echo 'Are you sure? (y/N) '" -l confirm
  if test "$confirm" = y -o "$confirm" = Y
    sudo wipefs -a $argv[1]
    sudo dd if=/dev/zero of=$argv[1] bs=1M count=100 status=progress
    sudo parted -s $argv[1] mklabel gpt
    sudo parted -s $argv[1] mkpart primary 1MiB 100%
    sudo parted -s $argv[1] set 1 msftdata on
    set partition "$argv[1]"
    if string match -q '*nvme*' $argv[1]
      set partition "$argv[1]p1"
    else
      set partition "$argv[1]1"
    end
    sudo partprobe $argv[1]; or true
    sudo udevadm settle; or true
    sudo mkfs.exfat -n $argv[2] $partition
    echo "Drive $argv[1] formatted as exFAT and labeled '$argv[2]'."
  end
end
