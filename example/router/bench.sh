#!/usr/bin/env bash

set -e # exit on error

PORT=3001
URL="http://127.0.0.1:$PORT"
DURATION="30s"
CONCURRENCY=400

# === 🏎 PERFORMANCE TUNING CONFIGURATION ===
SERVER_CORES="0-7"  # Pinned to Physical Cores 0-7 (8 threads total)
OHA_CORES="8-15"    # Pinned to Physical Cores 8-15 (8 threads total)
# ============================================

cleanup() {
    echo ""
    echo "🛑 Stopping zio-example server..."
    kill $SERVER_PID 2>/dev/null || true
    wait $SERVER_PID 2>/dev/null || true
}
trap cleanup EXIT

echo "🏎 Optimizing system environment (requires sudo)..."
# 1. Set CPU governor to performance to prevent dynamic clock frequency scaling
for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    if [ -f "$governor" ]; then
        echo performance | sudo tee "$governor" > /dev/null
    fi
done

# 2. Flush OS page caches to ensure a completely clean memory baseline
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

echo "🔨 Building example app in ReleaseFast mode..."
zig build -Doptimize=ReleaseFast

echo "🚀 Starting router-example server on $URL (Pinned to Cores: $SERVER_CORES)..."
# Pin the server to its isolated cores
taskset -c "$SERVER_CORES" ./zig-out/bin/router-example &
SERVER_PID=$!

# Wait for server to start listening
echo "⏳ Waiting for server to accept connections..."
MAX_WAIT=5
for i in $(seq 1 $MAX_WAIT); do
    if curl -s -o /dev/null --connect-timeout 1 "$URL" 2>/dev/null; then
        echo "✅ Server is ready"
        break
    fi
    if [ $i -eq $MAX_WAIT ]; then
        echo "❌ Server failed to start"
        exit 1
    fi
    sleep 1
done

# Define structural benchmark vectors
# Format: "METHOD|PATH|LABEL"
SCENARIOS=(
    "GET|/|1. Hello, World!"
)

for scenario in "${SCENARIOS[@]}"; do
    IFS="|" read -r method path label <<< "$scenario"

    echo ""
    echo "========================================================================="
    echo "🎯 $label"
    echo "   Target: $method $URL$path"
    echo "========================================================================="

    # Pin the benchmarking tool execution to the client cores
    taskset -c "$OHA_CORES" oha -z "$DURATION" -c "$CONCURRENCY" --no-tui \
        -m "$method" \
        "$URL$path"
done

echo ""
echo "✅ Complex router benchmark run finalized."
