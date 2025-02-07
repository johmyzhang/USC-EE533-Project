#!/bin/bash

TEAM=9
PW="y7Cv6i9/vacv"

# Hardcoded values for team 9
ND=4   # node index based on (TEAM % 5)
M0=9   # FPGA node (netfpga@nf9.usc.edu)
M1=5   # n0 (node4@nf5.usc.edu)
M2=6   # n1 (node4@nf6.usc.edu)
M3=7   # n2 (node4@nf7.usc.edu)
M4=8   # n3 (node4@nf8.usc.edu)

# Common SSH options
SSH_OPTS="-o StrictHostKeyChecking=no"
SSH_CMD="sshpass -p $PW ssh $SSH_OPTS"

# 1) FPGA Node
gnome-terminal -- bash -c "$SSH_CMD netfpga@nf$M0.usc.edu" &

# 2) n0
gnome-terminal -- bash -c "$SSH_CMD node$ND@nf$M1.usc.edu" &

# 3) n1
gnome-terminal -- bash -c "$SSH_CMD node$ND@nf$M2.usc.edu" &

# 4) n2
gnome-terminal -- bash -c "$SSH_CMD node$ND@nf$M3.usc.edu" &

# 5) n3
gnome-terminal -- bash -c "$SSH_CMD node$ND@nf$M4.usc.edu" &

# Optional: small pause so terminals have time to spawn
sleep 1
