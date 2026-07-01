#!/usr/bin/env bash

set -e

PORT=3001
BASE_URL="http://127.0.0.1:$PORT"
SERVER_CORES="0-7"
OHA_CORES="8-15"
CONCURRENCY=50
DURATION="30s"

# Lookup table
declare -A CASES=(
    ["req0bres13b"]="GET /b13b 0"
    ["req1kbres13b"]="POST /b13b 1024"
    ["req0bres1kb"]="GET /b1kb 0"
    ["req1kbres1kb"]="POST /b1kb 1024"
    ["req0bres1mb"]="GET /b1mb 0"
    ["req1mbres1mb"]="POST /b1mb 1048576"
)

# Run order
ORDERED_CASES=(
    "req0bres13b"
    "req1kbres13b"
    "req0bres1kb"
    "req1kbres1kb"
    "req0bres1mb"
    "req1mbres1mb"
)

echo "0) benchmarking"

echo "1) optimizing environment"
for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    if [ -f "$governor" ]; then 
        echo performance | sudo tee "$governor" > /dev/null
    fi
done
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

echo "2) building"
zig build -Doptimize=ReleaseFast

echo "2.1) killing leftover server processes..."
pkill -9 -f "basic-example" 2>/dev/null || true
sleep 1

echo "3) starting server"
taskset -c "$SERVER_CORES" ./zig-out/bin/basic-example &
SERVER_PID=$!

echo -n "4) waiting for server to accept connections"
MAX_WAIT=5
for w in $(seq 1 $MAX_WAIT); do
    echo -n "."
    if curl -s -o /dev/null --connect-timeout 1 "$BASE_URL" 2>/dev/null; then
        echo " server is ready"
        break
    fi
    if [ $w -eq $MAX_WAIT ]; then
        echo " server failed to start within $MAX_WAIT seconds"
        kill $SERVER_PID 2>/dev/null || true
        exit 1
    fi
    sleep 1
done

echo "5) running benchmarks"
for case in "${ORDERED_CASES[@]}"; do
    read -r method path body_size <<< "${CASES[$case]}"
    url="${BASE_URL}${path}"

    echo "--- $case ($method $path) ---"

    body_file=""
    if [ "$method" = "POST" ]; then
        body_file=$(mktemp)
        dd if=/dev/zero bs="$body_size" count=1 of="$body_file" status=none 2>/dev/null
        body_arg="-d @$body_file"
    else
        body_arg=""
    fi

    taskset -c "$OHA_CORES" oha \
        -z "$DURATION" \
        -c "$CONCURRENCY" \
        -m "$method" \
        $body_arg \
        --no-tui \
        "$url"

    if [ -n "$body_file" ]; then
        rm -f "$body_file"
    fi

    echo ""
done

echo "6) stopping server"
kill -9 $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true
sleep 1

echo "7) benchmark complete"
