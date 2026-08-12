#!/usr/bin/env bash
# Double-click version for macOS Finder. Does the same thing as deploy.sh,
# but keeps the Terminal window open at the end so you can read the result.
cd "$(dirname "$0")"
./deploy.sh
status=$?
echo
if [ $status -eq 0 ]; then
  echo "✅ Done — closing this window in 10s (or press Enter to close now)."
else
  echo "❌ Something went wrong (see above). Press Enter to close this window."
  read -r
  exit $status
fi
read -r -t 10
