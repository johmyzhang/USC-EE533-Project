#!/usr/bin/env bash

PW="y7Cv6i9/vacv"

# The remote user@host for the FPGA node
FPGA_HOST="netfpga@nf9.usc.edu"

# Optional SSH options to skip host key checking, etc.
SSH_OPTS="-o StrictHostKeyChecking=no"

# scp command using sshpass for password automation
SCP_CMD="sshpass -p $PW scp $SSH_OPTS"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <local_file1> [<local_file2> ...]"
  echo "Example: $0 my_bitfile.bit"
  exit 1
fi

echo "=== Starting upload to $FPGA_HOST ==="

for local_file in "$@"; do
  if [[ -f "$local_file" ]]; then
    echo "Uploading '$local_file' to $FPGA_HOST:~/"
    $SCP_CMD "$local_file" "$FPGA_HOST:~/"
  else
    echo "Warning: '$local_file' not found or is not a regular file."
  fi
done

echo "=== All requested files have been uploaded (if found) ==="
