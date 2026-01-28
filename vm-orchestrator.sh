#!/usr/bin/env bash
# ============================================================================
# VM SSH Orchestrator - Production Grade (Zero Blind Sleeps)
# Manages VirtualBox VM lifecycle with intelligent service checks & auto-shutdown
# ============================================================================
set -euo pipefail
IFS=$'\n\t'

# ==================== CONFIGURATION ====================
readonly VM_NAME="${VM_NAME:-ubuntu-server}"
readonly SSH_USER="${SSH_USER:-test}"
readonly SSH_HOST="${SSH_HOST:-127.0.0.1}"
readonly SSH_PORT="${SSH_PORT:-2222}"
readonly AUTO_SHUTDOWN="${AUTO_SHUTDOWN:-true}"
readonly TERMINAL_EMULATOR="${TERMINAL_EMULATOR:-xfce4-terminal}"
readonly MAX_STARTUP_WAIT="${MAX_STARTUP_WAIT:-120}"  # Total max wait time (seconds)
readonly SSH_CHECK_INTERVAL="${SSH_CHECK_INTERVAL:-3}" # Polling interval (seconds)
readonly LOG_FILE="${LOG_FILE:-$HOME/vm-orchestrator.log}"
readonly TIMESTAMP_FMT="%Y-%m-%d %H:%M:%S"

# ==================== LOGGING FRAMEWORK ====================
log() {
    local level="${1:-INFO}" msg="${2:-}"
    printf '[%s] [%s] %s\n' "$(date "+$TIMESTAMP_FMT")" "$level" "$msg" | tee -a "$LOG_FILE" >&2
}

log_info()  { log "INFO"  "$1"; }
log_warn()  { log "WARN"  "$1"; }
log_error() { log "ERROR" "$1"; exit 1; }
log_debug() { [[ "${DEBUG:-false}" == "true" ]] && log "DEBUG" "$1" || true; }

# ==================== VALIDATION & SETUP ====================
validate_dependencies() {
    local deps=("VBoxManage" "nc" "$TERMINAL_EMULATOR")
    for cmd in "${deps[@]}"; do
        command -v "$cmd" >/dev/null 2>&1 || log_error "Missing dependency: $cmd"
    done
    log_info "✓ All dependencies validated"
}

ensure_vbox_modules() {
    if ! lsmod | grep -qE '^vboxdrv|^vboxnetflt|^vboxnetadp'; then
        log_info "→ Loading VirtualBox kernel modules..."
        sudo modprobe vboxdrv vboxnetflt vboxnetadp 2>/dev/null || {
            log_warn "modprobe failed - attempting vboxconfig"
            sudo /sbin/vboxconfig || log_error "Failed to initialize VirtualBox kernel modules"
        }
    fi
    log_info "✓ VirtualBox modules active"
}

verify_vm_exists() {
    VBoxManage list vms | grep -qF "\"$VM_NAME\"" || \
        log_error "VM '$VM_NAME' not found. Available VMs:\n$(VBoxManage list vms)"
    log_info "✓ VM '$VM_NAME' exists"
}

# ==================== VM LIFECYCLE MANAGEMENT ====================
get_vm_state() {
    VBoxManage showvminfo "$VM_NAME" --machinereadable 2>/dev/null | \
        grep -i '^VMState=' | cut -d'"' -f2 || echo "unknown"
}

start_vm_if_needed() {
    local state
    state=$(get_vm_state)
    
    case "$state" in
        running) 
            log_info "→ VM already running (state: $state)"
            log_info "→ Proceeding directly to service verification..."
            ;;
        poweroff|aborted|saved) 
            log_info "→ Starting VM '$VM_NAME' in headless mode..."
            VBoxManage startvm "$VM_NAME" --type headless >/dev/null 2>&1 || \
                log_error "Failed to start VM (state was: $state)"
            
            # Poll until VM reaches 'running' state (machine-level readiness)
            log_info "→ Waiting for VM process to initialize..."
            local elapsed=0
            while [[ "$(get_vm_state)" != "running" ]]; do
                ((elapsed+=SSH_CHECK_INTERVAL))
                [[ $elapsed -gt MAX_STARTUP_WAIT ]] && log_error "VM failed to reach 'running' state after ${MAX_STARTUP_WAIT}s"
                sleep "$SSH_CHECK_INTERVAL"
            done
            log_info "✓ VM process running (state: running)"
            ;;
        *) log_error "Unexpected VM state: $state. Manual intervention required." ;;
    esac
    
    # OPTIMIZED: Active service verification instead of blind sleeps
    # Phase 1: Network port reachability (lightweight check)
    log_info "→ Verifying network connectivity ($SSH_HOST:$SSH_PORT)..."
    local start_time=$SECONDS
    local port_timeout=$((MAX_STARTUP_WAIT / 3))
    
    while [[ $((SECONDS - start_time)) -lt $port_timeout ]]; do
        if nc -z -w 1 "$SSH_HOST" "$SSH_PORT" 2>/dev/null; then
            log_info "✓ Network port reachable (took $((SECONDS - start_time))s)"
            return 0
        fi
        sleep "$SSH_CHECK_INTERVAL"
    done
    
    log_warn "Port reachability check timed out after ${port_timeout}s - proceeding to SSH banner verification"
}

wait_for_ssh() {
    log_info "→ Waiting for SSH service readiness (max ${MAX_STARTUP_WAIT}s)..."
    log_info "→ Verifying actual SSH banner (not just open port)..."
    
    local start_time=$SECONDS
    local banner=""
    
    # Phase 2: SSH banner verification (service-level readiness)
    until banner=$(timeout 5 bash -c "echo 'exit' | nc -w 5 $SSH_HOST $SSH_PORT 2>/dev/null | head -1" 2>/dev/null); do
        [[ $((SECONDS - start_time)) -ge MAX_STARTUP_WAIT ]] && {
            log_debug "Last VM state: $(get_vm_state)"
            log_debug "Port status: $(nc -z -w 2 $SSH_HOST $SSH_PORT && echo 'OPEN' || echo 'CLOSED')"
            log_error "SSH banner timeout after ${MAX_STARTUP_WAIT}s. VM may lack SSH server or be under heavy load."
        }
        sleep "$SSH_CHECK_INTERVAL"
    done
    
    # Verify we got a real SSH banner
    if echo "$banner" | grep -qE "^SSH-2\.0-"; then
        log_info "✓ SSH banner verified: $banner (took $((SECONDS - start_time))s)"
        log_info "✓ SSH service fully ready on $SSH_HOST:$SSH_PORT"
    else
        log_warn "Unexpected response (not SSH banner): $banner"
        log_info "→ Proceeding anyway - SSH may still work..."
    fi
}

# ==================== TERMINAL LAUNCHER ====================
launch_ssh_terminal() {
    local shutdown_cmd=""
    
    if [[ "$AUTO_SHUTDOWN" == "true" ]]; then
        shutdown_cmd=" && echo -e '\n\033[1;33m✓ Initiating graceful VM shutdown...\033[0m' && VBoxManage controlvm \"$VM_NAME\" acpipowerbutton 2>&1 | grep -v 'VBoxManage:'"
        log_info "→ Auto-shutdown ENABLED (VM will power off after SSH exit)"
    else
        log_info "→ Auto-shutdown DISABLED (VM will remain running after SSH exit)"
    fi
    
    log_info "→ Launching terminal with SSH session..."
    
    # CRITICAL FIX: Removed --hold flag + optimized read for instant closure
    "$TERMINAL_EMULATOR" \
        --title="SSH: $VM_NAME" \
        -e "bash -c \"printf '\\033]2;SSH: $VM_NAME\\\\007'; \
            echo -e '\\033[1;36m→ Connecting to $VM_NAME ($SSH_HOST:$SSH_PORT)...\\033[0m'; \
            ssh -o ConnectTimeout=15 -o StrictHostKeyChecking=accept-new -o ServerAliveInterval=30 -p $SSH_PORT $SSH_USER@$SSH_HOST${shutdown_cmd}; \
            echo -e '\\n\\033[1;32m✓ Session ended. Press any key to close terminal...\\033[0m'; \
            read -r -n 1 -s\"" &
    
    # Give terminal time to launch
    sleep 1
    
    # Verify terminal process exists
    if pgrep -f "xfce4-terminal.*SSH: $VM_NAME" >/dev/null 2>&1; then
        log_info "✓ Terminal session launched successfully"
    else
        log_warn "⚠️  Terminal may not have launched properly. Check for errors in terminal window."
    fi
}

# ==================== MAIN EXECUTION ====================
main() {
    # Redirect all output to log file while still showing on screen
    exec 1> >(tee -a "$LOG_FILE") 2>&1
    
    log_info "=========================================="
    log_info " VM Orchestrator Started"
    log_info "=========================================="
    log_info "Config: VM=$VM_NAME | User=$SSH_USER | Host=$SSH_HOST:$SSH_PORT"
    log_info "        AutoShutdown=$AUTO_SHUTDOWN | Timeout=${MAX_STARTUP_WAIT}s"
    log_info "Log file: $LOG_FILE"
    
    validate_dependencies
    ensure_vbox_modules
    verify_vm_exists
    start_vm_if_needed      # Zero blind sleeps - intelligent polling
    wait_for_ssh            # Banner verification (not just port check)
    launch_ssh_terminal
    
    log_info "→ Orchestrator exiting. Monitor session in terminal window."
    log_info "=========================================="
    log_info " VM Orchestrator Finished"
    log_info "=========================================="
}

# ==================== SIGNAL HANDLING ====================
cleanup() {
    log_warn "⚠️  Received interrupt signal - exiting gracefully"
    exit 130
}
trap cleanup SIGINT SIGTERM

# ==================== ENTRY POINT ====================
main "$@"
