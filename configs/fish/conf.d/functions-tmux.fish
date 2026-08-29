function t
    set session (basename $PWD)
    tmux attach -t $session 2>/dev/null; or tmux new -s $session
end

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
    set session (basename $current_dir)
    set ai $argv[1]
    set editor_pane $TMUX_PANE
    tmux rename-session $session 2>/dev/null
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

function ts
    set session (tmux list-sessions -F '#S' | fzf --prompt="session> ")
    and tmux switch-client -t $session
end

function tl
    tmux list-sessions -F '#S: #{session_windows} windows, #{session_created}' 2>/dev/null
    or echo "No active sessions"
end

function tk
    set session (tmux list-sessions -F '#S' | fzf --prompt="kill> ")
    and tmux kill-session -t $session
end
