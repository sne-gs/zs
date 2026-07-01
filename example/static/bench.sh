#!/usr/bin/env bash

set -e  # exit on error

PORT=3001
URL="http://127.0.0.1:$PORT"
OHA_CMD="oha -z 30s -c 400 --no-tui $URL"

echo "🔨 Building example app in ReleaseFast mode..."
zig build -Doptimize=ReleaseFast

echo "🚀 Starting zs-example server on $URL ..."
./zig-out/bin/zs-example &
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
echo "📊 Running oha benchmark..."
$OHA_CMD

# Clean shutdown
echo "🛑 Stopping zs-example server..."
kill $SERVER_PID
wait $SERVER_PID 2>/dev/null || true

echo "✅ Benchmark complete."
