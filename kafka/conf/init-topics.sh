#!/bin/bash

set -euo pipefail

echo "🔧 Creating topics from topics.conf..."

# Check if the file exists
if [[ ! -f /topics.conf ]]; then
  echo "❌ File /topics.conf does not exist!"
  exit 1
fi

# Iterate through the lines of the config
while IFS='=' read -r topic partitions; do
  # Skip empty lines and comments
  if [[ -z "$topic" || "$topic" =~ ^# ]]; then
    continue
  fi

  # Remove any spaces
  topic=$(echo "$topic" | xargs)
  partitions=$(echo "$partitions" | xargs)

  echo "📝 Creating topic: $topic with $partitions partitions"
  kafka-topics --bootstrap-server kafka:29092 \
    --create --if-not-exists \
    --topic "$topic" \
    --partitions "$partitions" \
    --replication-factor 1 || echo "⚠️ Topic $topic may already exist"
done < /topics.conf