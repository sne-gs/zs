#!/usr/bin/env bash

set -e

PORT=3001
URL="http://127.0.0.1:$PORT/b13b"
SERVER_CORES="0-7"
OHA_CORES="8-15"
CONCURRENCY=400
DURATION="15s"

echo "0) benchmarking"

echo "1) optimizing environment"
for governor in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    if [ -f "$governor" ]; then 
        echo performance | sudo tee "$governor" > /dev/null
    fi
done
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

echo "2) cleaning"
pkill -9 -f "basic-example" 2>/dev/null || true
sleep 1

echo "3) building"
zig build -Doptimize=ReleaseFast

echo -n "4) starting server"
taskset -c "$SERVER_CORES" ./zig-out/bin/basic-example &
SERVER_PID=$!

MAX_WAIT=5
for w in $(seq 1 $MAX_WAIT); do
    echo -n "."
    if curl -s -o /dev/null --connect-timeout 1 "$URL" 2>/dev/null; then
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

taskset -c "$OHA_CORES" oha \
    -z "$DURATION" \
    -c "$CONCURRENCY" \
    -m GET \
    --no-tui \
    "$URL"

echo "6) stopping server"
kill -9 $SERVER_PID 2>/dev/null || true
wait $SERVER_PID 2>/dev/null || true
sleep 1

echo "7) benchmark complete"
