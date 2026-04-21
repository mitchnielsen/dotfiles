#!/bin/bash

# <xbar.title>GitHub PR Reviews</xbar.title>
# <xbar.author>mitch</xbar.author>
# <xbar.desc>Open PRs requesting review from @mitchnielsen</xbar.desc>

# <swiftbar.hideAbout>true</swiftbar.hideAbout>
# <swiftbar.hideRunInTerminal>true</swiftbar.hideRunInTerminal>
# <swiftbar.hideLastUpdated>true</swiftbar.hideLastUpdated>
# <swiftbar.hideDisablePlugin>true</swiftbar.hideDisablePlugin>
# <swiftbar.hideSwiftBar>true</swiftbar.hideSwiftBar>

export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

PRS=$(gh search prs \
  --state=open \
  --review-requested=mitchnielsen \
  --archived=false \
  --draft=false \
  --json repository,number,title,url \
  -- -label:automated-dependency-updates -label:dependencies -reviewed-by:@me -review-requested:Engineering \
  2>/dev/null)

COUNT=$(echo "$PRS" | jq -r 'length' 2>/dev/null)
if [ -z "$COUNT" ] || [ "$COUNT" = "null" ]; then
  COUNT=0
fi

if [ "$COUNT" -gt 0 ]; then
  color="#8b0000"
else
  color="#2e8b57"
fi

REVIEW_URL="https://github.com/pulls?q=is%3Aopen+is%3Apr+review-requested%3Amitchnielsen+archived%3Afalse+draft%3Afalse+-label%3Aautomated-dependency-updates+-label%3Adependencies+-reviewed-by%3A%40me+-review-requested%3AEngineering"

echo ":arrow.triangle.branch: $COUNT | sfcolor=$color"
echo "---"
echo "Open review queue | href=$REVIEW_URL"
echo "---"

if [ "$COUNT" -gt 0 ]; then
  echo "$PRS" | jq -r '.[] | "\(.repository.nameWithOwner)#\(.number)  \(.title)|\(.url)"' 2>/dev/null | \
    while IFS='|' read -r display url; do
      echo "$display | href=$url"
    done
  echo "---"
fi

echo "Refresh | refresh=true"
