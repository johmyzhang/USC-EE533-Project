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
SCP_CMD="sshpass -p $PW scp $SSH_OPTS"

# Create a local directory for logs, if not already exists
mkdir -p logs

# For each node, pull back iperf logs from its home directory into ./logs
for i in "${!NODES[@]}"; do
  nodeName="${NODES[$i]}"
  host="${HOSTS[$i]}"

  echo "=== Retrieving logs from $nodeName ($host) ==="

  # For example, if you have server logs named:
  #   ~/iperf_server_n0.log, 
  #   ~/iperf_server_n1.log, etc.,
  # …and possibly client logs named:
  #   ~/iperf_client_n0_to_n1.log, etc.

  # We'll attempt to copy *any* file that starts with iperf_ in the home directory.
  # If you want to be more specific, you can individually list filenames.
  
  $SCP_CMD "$host:~/udp_server_*.log" ./logs/ 2>/dev/null || \
    echo "No logs found or scp error from $nodeName"
done

echo "=== All logs have been copied to ./logs/ ==="

# ./copy_files.sh