#!/usr/bin/env bash

PW="y7Cv6i9/vacv"

# Hardcoded SSH logins for each node
n0_host="node4@nf5.usc.edu"  # n0
n1_host="node4@nf6.usc.edu"  # n1
n2_host="node4@nf7.usc.edu"  # n2
n3_host="node4@nf8.usc.edu"  # n3

NODES=(n0 n1 n2 n3)
HOSTS=("$n0_host" "$n1_host" "$n2_host" "$n3_host")

SSH_OPTS="-o StrictHostKeyChecking=no"
SSH_CMD="sshpass -p $PW ssh $SSH_OPTS"

for i in "${!NODES[@]}"; do
  serverNode="${NODES[$i]}"
  serverHost="${HOSTS[$i]}"

  echo "=== Starting iperf server on $serverNode ==="
  # Use nohup to run iperf in the background
  $SSH_CMD "$serverHost" "nohup iperf -s &> /dev/null &"

  sleep 1  # Give the server a moment to fully start

  # Each of the OTHER nodes acts as client
  for j in "${!NODES[@]}"; do
    if [ "$j" != "$i" ]; then
      clientNode="${NODES[$j]}"
      clientHost="${HOSTS[$j]}"

      # The variable \$${serverNode} must be known on the remote client (e.g. `export n0=10.0.0.4`)
      result=$($SSH_CMD "$clientHost" "iperf -c \$${serverNode} -t 2")
      echo "$clientNode -> $serverNode"
      echo "$result"
      echo
      sleep 1
    fi
  done

  echo "=== Stopping iperf server on $serverNode ==="
  echo ""
  echo ""
  echo "============================================"
  
  # Force-kill the iperf server
  $SSH_CMD "$serverHost" "pid=\$(pgrep iperf) && [ -n \"\$pid\" ] && kill -9 \$pid"
  sleep 1
done

# ./performance_test_tcp.sh > tcp_server_performance.log
