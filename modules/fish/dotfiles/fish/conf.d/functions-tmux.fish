function tdl
  if test (count $argv) -lt 1
    echo "Usage: tdl <c|cx|codex|other_ai> [<second_ai>]"
    return 1
  end
  if not set -q TMUX
    echo "You must start tmux to use tdl."
    return 1
  end
  set current_dir "$PWD"
  set ai $argv[1]
  set editor_pane $TMUX_PANE
  tmux rename-window -t $editor_pane (basename $current_dir)
  tmux split-window -v -p 15 -t $editor_pane -c $current_dir
  set ai_pane (tmux split-window -h -p 30 -t $editor_pane -c $current_dir -P -F '#{pane_id}')
  if test (count $argv) -ge 2
    set ai2 $argv[2]
    set ai2_pane (tmux split-window -v -t $ai_pane -c $current_dir -P -F '#{pane_id}')
    tmux send-keys -t $ai2_pane $ai2 C-m
  end
  tmux send-keys -t $ai_pane $ai C-m
  tmux send-keys -t $editor_pane "$EDITOR ." C-m
  tmux select-pane -t $editor_pane
end

function tdlm
  if test (count $argv) -lt 1
    echo "Usage: tdlm <c|cx|codex|other_ai> [<second_ai>]"
    return 1
  end
  if not set -q TMUX
    echo "You must start tmux to use tdlm."
    return 1
  end
  set ai $argv[1]
  set ai2 $argv[2..-1]
  set base_dir $PWD
  set first true
  tmux rename-session (basename $base_dir | tr '.:' '--')
  for dir in $base_dir/*/
    if not test -d $dir
      continue
    end
    set dirpath (string trim -r -c / $dir)
    if $first
      tmux send-keys -t $TMUX_PANE "cd '$dirpath' && tdl $ai $ai2" C-m
      set first false
    else
      set pane_id (tmux new-window -c $dirpath -P -F '#{pane_id}')
      tmux send-keys -t $pane_id "tdl $ai $ai2" C-m
    end
  end
end

function tsl
  if test (count $argv) -lt 2
    echo "Usage: tsl <pane_count> <command>"
    return 1
  end
  if not set -q TMUX
    echo "You must start tmux to use tsl."
    return 1
  end
  set count $argv[1]
  set cmd $argv[2]
  set current_dir $PWD
  set -a panes $TMUX_PANE
  tmux rename-window -t $TMUX_PANE (basename $current_dir)
  while test (count $panes) -lt $count
    set split_target $panes[-1]
    set new_pane (tmux split-window -h -t $split_target -c $current_dir -P -F '#{pane_id}')
    set -a panes $new_pane
    tmux select-layout -t $panes[1] tiled
  end
  for pane in $panes
    tmux send-keys -t $pane $cmd C-m
  end
  tmux select-pane -t $panes[1]
end

function tcd
  if test (count $argv) -lt 1
    echo "Usage: tcd <directory>"
    return 1
  end
  set dir (realpath $argv[1])
  if not test -d "$dir"
    echo "Error: Not a directory: $dir"
    return 1
  end
  builtin cd "$dir"
  if set -q TMUX
    tmux display-message "tcd: $dir"
  end
end
