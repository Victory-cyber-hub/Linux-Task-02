#!/usr/bin/env bash
# Secure File Management & User Configuration - command reference
# IMPORTANT:
# This script is intentionally a reference, not a fully automatic execution script.
# The workflow requires switching to agent007 before file operations.

set -e

echo "[1] Create user (run from an existing sudo-capable account)"
echo 'sudo useradd -m -s /bin/bash -G sudo agent007'
echo 'sudo passwd agent007'
echo 'su - agent007'

echo
echo "[2] Verify identity"
echo 'whoami'
echo 'pwd'

echo
echo "[3] Create workspace"
echo 'mkdir -p /home/agent007/mission/intel'
echo 'mkdir -p /home/agent007/mission/ops/backup'
echo 'cd /home/agent007/mission'

echo
echo "[4] Create files"
echo 'cd /home/agent007/mission/intel'
echo 'touch targets.txt routes.txt keys.txt'

echo
echo "[5] Capture listings"
echo 'ls > listing1.txt'
echo 'ls -l > listing2.txt'
echo 'ls -la > listing3.txt'

echo
echo "[6] Copy and remove"
echo 'cp routes.txt ../ops/backup/'
echo 'rm keys.txt'

echo
echo "[7] Permissions"
echo 'chmod 640 targets.txt'
echo 'ls -l targets.txt'

echo
echo "[8] Error simulation and recovery"
echo 'rm ../ops/backup/routes.txt'
echo 'cp routes.txt ../ops/backup/'

echo
echo "[9] Ownership exercise - administrative step"
echo 'sudo chown root:root /home/agent007/mission/intel/targets.txt'
echo 'ls -l /home/agent007/mission/intel/targets.txt'

echo
echo "[10] Final verification"
echo 'ls -laR /home/agent007/mission/'
