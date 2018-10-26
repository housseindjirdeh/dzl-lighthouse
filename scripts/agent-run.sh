#!/bin/bash

export LH_PATH="$HOME/lighthouse"
export DZL_PATH="$HOME/dzl"
export DISPLAY=:99.0
export CHROME_PATH="$(which google-chrome-stable)"

xdpyinfo -display $DISPLAY > /dev/null || Xvfb $DISPLAY -screen 0 1024x768x16 &

cd "$LH_PATH" || exit 1

git checkout -f origin/master || exit 1
git pull origin master || exit 1
export LH_HASH=$(git rev-parse HEAD)

export LABEL_PREFIX="official-ci"
if grep -q "$LH_HASH" last-processed-hash.report.json; then
  echo "Hash has not changed since last processing, will be a continuous run."
  export LABEL_PREFIX="official-continuous"
else
  yarn install
fi

cd "$DZL_PATH" || exit 1

node ./bin/dzl.js collect --limit=1 --label="$LABEL_PREFIX-control" --hash="$LH_HASH" --concurrency=1 --config=./agent.control.config.js
DZL_EXIT_CODE=$?
[ $DZL_EXIT_CODE -eq 0 ] || exit 1

node ./bin/dzl.js collect --limit=1 --label="$LABEL_PREFIX-wild" --hash="$LH_HASH" --concurrency=1 --config=./agent.wild.config.js
DZL_EXIT_CODE=$?

if [ $DZL_EXIT_CODE -eq 0 ]; then
  echo "Success!"
  echo "$LH_HASH" > "$LH_PATH/last-processed-hash.report.json"
else
  echo "Failed, exiting with error code 1"
  exit 1
fi


