function v
  set -l editor nvim
  if set -q EDITOR
    set editor $EDITOR
  end
  $editor $argv
end

function n
  if test (count $argv) -eq 0
    command nvim .
  else
    command nvim $argv
  end
end

function ff
  if test "$TERM" = alacritty && command -v alacritty >/dev/null
    fzf --preview 'file=$(file --mime-type -b {}); switch $file; case "image/*"; alacritty msg --help >/dev/null 2>&1 && echo "image preview not supported"; case "*"; bat --style=numbers --color=always {}; end'
  else
    fzf --preview 'bat --style=numbers --color=always {}'
  end
end

function eff
  set -l editor nvim
  if set -q EDITOR
    set editor $EDITOR
  end
  $editor (ff)
end

function sff
  if test (count $argv) -eq 0
    echo "Usage: sff <destination> (e.g. sff host:/tmp/)"
    return 1
  end
  set file (command find . -type f -printf '%T@\t%p\n' | sort -rn | cut -f2- | ff)
  if test -n "$file"
    scp "$file" $argv[1]
  end
end

function zd
  if test (count $argv) -eq 0
    builtin cd ~; or return
  else if test -d $argv[1]
    builtin cd $argv[1]
  else
    if not z $argv[1]
      echo "Error: Directory not found"
      return 1
    end
    echo "󰅩"
    pwd
  end
end

function open
  xdg-open $argv >/dev/null 2>&1 &
end

function compress
  tar -czf "$argv[1]".tar.gz "$argv[1]"
end

function decompress
  tar -xzf $argv
end
