#!/usr/bin/env bash
# freedom – SOCKS proxy via SSH tunnel. Set/unset proxy env, use on restricted servers.
# Run "shell" on the restricted server to get a session where all traffic uses the proxy.

PROXY_PORT="${PROXY_PORT:-1081}"
PROXY_URL="socks5h://127.0.0.1:${PROXY_PORT}"

usage() {
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  shell [ip] [user]     Start tunnel in background and open a shell WITH proxy set"
    echo "                        (use this on the restricted server - no second SSH needed)"
    echo "  start [ip] [user]     Start SSH SOCKS tunnel (foreground)"
    echo "  start-bg [ip] [user]  Start tunnel in background"
    echo "  set                   Print export commands; use: eval \$( $0 set )"
    echo "  unset                 Print unset commands; use: eval \$( $0 unset )"
    echo "  curl <url>            Run curl through the proxy"
    echo "  status                Show current proxy env (env | grep proxy)"
    echo "  stop                  Kill the SSH tunnel (if started in background)"
    echo ""
    echo "Environment (optional):"
    echo "  PROXY_PORT=1081       SOCKS port (default: 1081)"
    echo "  SSH_USER=root         Default SSH user"
    exit 0
}

cmd_start() {
    local ip="$1"
    local user="${2:-${SSH_USER:-root}}"
    if [ -z "$ip" ]; then
        read -p "Enter SSH server IP or hostname: " ip
        [ -z "$ip" ] && { echo "IP required."; exit 1; }
    fi
    if [ -z "$user" ]; then
        read -p "Enter SSH user [root]: " user
        user="${user:-root}"
    fi
    echo "Starting SOCKS proxy on 127.0.0.1:${PROXY_PORT} (ssh ${user}@${ip})..."
    echo "Press Ctrl+C to stop the tunnel."
    ssh -N -D "$PROXY_PORT" "${user}@${ip}"
}

cmd_start_bg() {
    local ip="$1"
    local user="${2:-${SSH_USER:-root}}"
    [ -z "$ip" ] && { read -p "Enter SSH server IP or hostname: " ip; [ -z "$ip" ] && exit 1; }
    [ -z "$user" ] && user="${user:-root}"
    ssh -f -N -D "$PROXY_PORT" "${user}@${ip}" && echo "Tunnel running on port ${PROXY_PORT}." || exit 1
}

# Start tunnel in background and replace this process with a shell that has proxy set.
# Use on the restricted server: one SSH session, then run "shell" – no second SSH needed.
cmd_shell() {
    local ip="$1"
    local user="${2:-${SSH_USER:-root}}"
    if [ -z "$ip" ]; then
        read -p "Enter proxy server IP (machine with open internet): " ip
        [ -z "$ip" ] && { echo "IP required."; exit 1; }
    fi
    if [ -z "$user" ]; then
        read -p "Enter SSH user on that server [root]: " user
        user="${user:-root}"
    fi
    echo "Starting SOCKS tunnel to ${user}@${ip} on port ${PROXY_PORT}..."
    if ! ssh -f -N -D "$PROXY_PORT" "${user}@${ip}"; then
        echo "Failed to start tunnel."
        exit 1
    fi
    echo "Tunnel running. Opening shell with proxy set ($PROXY_URL). Use 'exit' to leave."
    exec env http_proxy="$PROXY_URL" https_proxy="$PROXY_URL" "${SHELL:-bash}"
}

cmd_set() {
    echo "export http_proxy=\"$PROXY_URL\"; export https_proxy=\"$PROXY_URL\"; echo \"Proxy set: $PROXY_URL\""
}

cmd_unset() {
    echo "unset http_proxy https_proxy; echo \"Proxy unset.\""
}

cmd_curl() {
    local url="$1"
    [ -z "$url" ] && { read -p "Enter URL to fetch: " url; [ -z "$url" ] && exit 1; }
    curl -L --proxy "$PROXY_URL" "$url"
}

cmd_status() {
    echo "Proxy URL: $PROXY_URL"
    env | grep -i proxy || echo "(no proxy variables set)"
}

cmd_stop() {
    local pid
    pid=$(pgrep -f "ssh -[f]*N -D ${PROXY_PORT}")
    if [ -n "$pid" ]; then
        kill $pid && echo "Tunnel stopped (PID $pid)." || echo "Failed to stop."
    else
        echo "No SSH tunnel found on port ${PROXY_PORT}."
    fi
}

case "${1:-}" in
    shell)   cmd_shell "$2" "$3" ;;
    start)   cmd_start "$2" "$3" ;;
    start-bg) cmd_start_bg "$2" "$3" ;;
    set)     cmd_set ;;
    unset)   cmd_unset ;;
    curl)    cmd_curl "$2" ;;
    status)  cmd_status ;;
    stop)    cmd_stop ;;
    -h|--help|help|"") usage ;;
    *)       echo "Unknown command: $1"; usage ;;
esac
