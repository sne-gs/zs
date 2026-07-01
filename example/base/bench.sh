#!/usr/bin/env bash

set -e

PORT=3001
# 1. Update the base and target URLs to hit your explicit route
BASE_URL="http://127.0.0.1:$PORT"
TARGET_URL="$BASE_URL/"

SERVER_CORES="0-7"
OHA_CORES="8-15"

LABELS=("1KB" "64KB" "1MB")
BYTES=(1024 65536 1048576)

echo "🏎️ Optimizing system environment (requires sudo)..."
for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    if [ -f "$governor" ]; then 
        echo performance | sudo tee "$governor" > /dev/null
    fi
done

sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

echo "🔨 Building example app in ReleaseFast mode..."
zig build -Doptimize=ReleaseFast

TEMP_PAYLOAD="current_benchmark_body.bin"

for i in "${!LABELS[@]}"; do
    SIZE_LABEL="${LABELS[$i]}"
    SIZE_BYTES="${BYTES[$i]}"

    echo ""
    echo "========================================================="
    echo "📊 Preparing Benchmark for Body Size: $SIZE_LABEL ($SIZE_BYTES bytes)"
    echo "========================================================="

    head -c "$SIZE_BYTES" /dev/urandom > "$TEMP_PAYLOAD"

    echo "🚀 Starting server on $BASE_URL (Pinned to Cores: $SERVER_CORES)..."
    taskset -c "$SERVER_CORES" ./zig-out/bin/base-example &
    SERVER_PID=$!

    echo "⏳ Waiting for server to accept connections..."
    MAX_WAIT=5
    for w in $(seq 1 $MAX_WAIT); do
        # 2. Use the base URL for the TCP connection health check.
        # It doesn't matter if the root returns a 404 or 405; as long as curl 
        # connects successfully, the server is alive and listening.
        if curl -s -o /dev/null --connect-timeout 1 "$BASE_URL" 2>/dev/null; then
            echo "✅ Server is ready"
            break
        fi
        if [ $w -eq $MAX_WAIT ]; then
            echo "❌ Server failed to start within $MAX_WAIT seconds"
            kill $SERVER_PID 2>/dev/null || true
            rm -f "$TEMP_PAYLOAD"
            exit 1
        fi
        sleep 1
    done

    if [ "$SIZE_LABEL" == "1MB" ]; then
        CONCURRENCY=50
    else
        CONCURRENCY=400
    fi

    echo "🔥 Running oha benchmark for 20s (Pinned to Cores: $OHA_CORES)..."
    # 3. Point oha at the explicit TARGET_URL matching your route
    taskset -c "$OHA_CORES" oha \
        -z 20s \
        -c "$CONCURRENCY" \
        -m POST \
        -D "$TEMP_PAYLOAD" \
        -H "Content-Type: application/octet-stream" \
        --no-tui \
        "$TARGET_URL"

    echo "🛑 Stopping server for $SIZE_LABEL run..."
    kill $SERVER_PID
    wait $SERVER_PID 2>/dev/null || true
    rm -f "$TEMP_PAYLOAD"
    
    sleep 1 
done

echo ""
echo "✅ All benchmarks complete."
