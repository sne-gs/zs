#!/usr/bin/env bash

set -e  # exit on error

PORT=3001
URL="http://127.0.0.1:$PORT"

# === 🏎️ PERFORMANCE TUNING CONFIGURATION ===
SERVER_CORES="0-7"  # Pinned to Physical Cores 0, 1, 2, 3 (8 threads total)
OHA_CORES="8-15"    # Pinned to Physical Cores 4, 5, 6, 7 (8 threads total)
# ============================================

OHA_CMD="oha -z 30s -c 400 --no-tui $URL"

# Get binary name from the current directory (assumes project name matches)
BIN_NAME=$(basename "$PWD")
BIN_PATH="./target/release/$BIN_NAME"

echo "🏎️ Optimizing system environment (requires sudo)..."
# 1. Set CPU governor to performance to prevent dynamic clock frequency scaling
for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    if [ -f "$governor" ]; then 
        echo performance | sudo tee "$governor" > /dev/null
    fi
done

# 2. Flush OS page caches to ensure a completely clean memory baseline
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

echo "🔨 Building Rust app in release mode..."
cargo build --release

echo "🚀 Starting $BIN_NAME server on $URL (Pinned to Cores: $SERVER_CORES)..."
taskset -c "$SERVER_CORES" "$BIN_PATH" &
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
        echo "❌ Server failed to start within $MAX_WAIT seconds"
        kill $SERVER_PID 2>/dev/null || true
        exit 1
    fi
    sleep 1
done

# Run the benchmark
echo "📊 Running oha benchmark (Pinned to Cores: $OHA_CORES)..."
taskset -c "$OHA_CORES" $OHA_CMD

# Clean shutdown
echo "🛑 Stopping $BIN_NAME server..."
kill $SERVER_PID
wait $SERVER_PID 2>/dev/null || true

echo "✅ Benchmark complete."
