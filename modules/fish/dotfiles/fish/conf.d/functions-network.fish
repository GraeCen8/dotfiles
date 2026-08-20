function fip
  if test (count $argv) -lt 2
    echo "Usage: fip <host> <port1> [port2] ..."
    return 1
  end
  set host $argv[1]
  set ports $argv[2..-1]
  for port in $ports
    ssh -f -N -L "$port:localhost:$port" $host
    and echo "Forwarding localhost:$port -> $host:$port"
  end
end

function dip
  if test (count $argv) -eq 0
    echo "Usage: dip <port1> [port2] ..."
    return 1
  end
  for port in $argv
    pkill -f "ssh.*-L $port:localhost:$port"
    and echo "Stopped forwarding port $port"
    or echo "No forwarding on port $port"
  end
end

function lip
  set forwards (pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+")
  if test -n "$forwards"
    echo $forwards
  else
    echo "No active forwards"
  end
end
