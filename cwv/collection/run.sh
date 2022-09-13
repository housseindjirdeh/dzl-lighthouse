#!/bin/bash

set -euxo pipefail

whoami
export HOME="/home/lighthouse"
cd /home/lighthouse

BLOCKED_PATTERNS=$(cat blocked-patterns.txt)
echo "Blocked patterns are..."
echo "$BLOCKED_PATTERNS"

for url in $(cat urls.txt)
do
  echo "---------------------------------"
  echo "----- $url -----"
  echo "---------------------------------"
  bash ./run-on-url.sh "$url" "$BLOCKED_PATTERNS" || echo "Run on $url failed :("
done

sudo cp entity.txt data/
sudo cp urls.txt data/
sudo cp blocked-patterns.txt data/
sudo tar -czf trace-data.tar.gz data/
sudo find data/ -name "lhr.json" -o -name "*.txt" | sudo tar -czf lhr-data.tar.gz -T -

echo "Run complete!"
