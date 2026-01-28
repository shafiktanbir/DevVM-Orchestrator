#!/bin/bash

# ================= CONFIG =================
VM_NAME="ubuntu-server"       # VirtualBox VM name
USER="test"                   # SSH username
HOST="127.0.0.1"              # Host IP for port forwarding
PORT="2222"                   # Host port forwarded to VM's SSH (22)
WAIT_TIME=2                   # Seconds to wait between SSH checks
SSH_TIMEOUT=15                # Timeout per nc check
AUTO_SHUTDOWN=true            # Set true to shutdown VM when SSH exits
TERMINAL_CMD="xfce4-terminal" # Your terminal emulator
LOGFILE="$HOME/connect-vm.log"

# ================= FUNCTIONS =================
log() {
    echo "$(date '+%H:%M:%S') | $1" | tee -a "$LOGFILE"
}

# ================= STEP 1: Ensure VirtualBox kernel modules =================
if ! lsmod | grep -q vboxdrv; then
    log "Loading VirtualBox kernel modules..."
    sudo modprobe vboxdrv
    sudo modprobe vboxnetflt
    sudo modprobe vboxnetadp
    log "Modules loaded."
else
    log "VirtualBox kernel modules already loaded."
fi

# ================= STEP 2: Check VM state =================
VM_STATE=$(VBoxManage showvminfo "$VM_NAME" --machinereadable | grep -i VMState= | cut -d'"' -f2)
if [[ "$VM_STATE" == "running" ]]; then
    log "VM '$VM_NAME' is already running."
else
    log "Starting VM '$VM_NAME' in headless mode..."
    VBoxManage startvm "$VM_NAME" --type headless 2>/dev/null
fi

# ================= STEP 3: Wait until SSH port is ready =================
log "Waiting for SSH on $HOST:$PORT..."
until nc -z -v -w $SSH_TIMEOUT $HOST $PORT; do
    sleep $WAIT_TIME
done
log "SSH port is ready!"

# ================= STEP 4: Open SSH in new terminal =================
log "Opening SSH session in new terminal..."
$TERMINAL_CMD -- bash -c "ssh -p $PORT $USER@$HOST; $([ $AUTO_SHUTDOWN = true ] && echo 'VBoxManage controlvm \"$VM_NAME\" acpipowerbutton'); exec bash"

log "Done. SSH session closed."

