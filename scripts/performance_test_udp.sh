#!/usr/bin/env bash

PW="y7Cv6i9/vacv"

# Hardcoded SSH logins
n0_host="node4@nf5.usc.edu"  # n0
n1_host="node4@nf6.usc.edu"  # n1
n2_host="node4@nf7.usc.edu"  # n2
n3_host="node4@nf8.usc.edu"  # n3

NODES=(n0 n1 n2 n3)
HOSTS=("$n0_host" "$n1_host" "$n2_host" "$n3_host")

SSH_OPTS="-o StrictHostKeyChecking=no"
SSH_CMD="sshpass -p $PW ssh $SSH_OPTS"

# 1) Start iperf servers in UDP mode on all nodes (in the background).
echo "=== Starting UDP iperf servers on all nodes ==="
for i in "${!NODES[@]}"; do
  serverHost="${HOSTS[$i]}"
  serverNode="${NODES[$i]}"
  
  echo "Starting server on ${NODES[$i]} ($serverHost)"
  # Run iperf in UDP mode, detach with nohup, suppress output
  $SSH_CMD "$serverHost" "
    nohup iperf -s -u \
    > ~/udp_server_${serverNode}_performance.log 2>&1 &
  "
done

# Give them a moment to start
sleep 3

# 2) Launch the UDP clients from every node to every other node at ~1Gbit/s,
#    with 512-byte packets, for 30 seconds. Each client runs in the background
#    *on its own node* so they start roughly simultaneously.
echo "=== Launching UDP iperf clients on all nodes (simultaneously) ==="
for i in "${!NODES[@]}"; do
  clientNode="${NODES[$i]}"
  clientHost="${HOSTS[$i]}"

  for j in "${!NODES[@]}"; do
    if [ "$i" != "$j" ]; then
      serverNode="${NODES[$j]}"
      # Note: -b 1G  => 1 Gigabit/s
      #       -u     => UDP
      #       -t 30  => 30 seconds
      #       -l 512 => 512-byte datagram
      echo "Launching client from $clientNode -> $serverNode"
      # $SSH_CMD "$clientHost" "
      #   nohup iperf -c \$$serverNode -u -b 1G -t 30 -l 512 \
      #   > ~/iperf_client_${clientNode}_to_${serverNode}.log 2>&1 &
      # "
      $SSH_CMD "$clientHost" "
        nohup iperf -c \$$serverNode -u -b 1G -t 30 -l 512 &> /dev/null &
      "
    fi
  done
done

# 3) Wait ~35 seconds (a bit more than 30) for all tests to complete
#    before cleaning up servers.
echo "Waiting 35 seconds for traffic to finish..."
sleep 35

# 4) Kill all iperf processes on each node
echo "=== Cleaning up (kill iperf) ==="
for i in "${!NODES[@]}"; do
  host="${HOSTS[$i]}"
  echo "Stopping iperf on ${NODES[$i]} ($host)"
  # Force-kill if normal pkill fails
  $SSH_CMD "$host" "pkill iperf || kill -9 \$(pgrep iperf) 2>/dev/null"
done

echo "All done!"

# ./performance_test_udp.sh
