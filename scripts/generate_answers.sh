#!/bin/bash

BASE_DIR="tests/answers"
TEMPLATE_DIR="$BASE_DIR/templates"
OUTPUT_DIR="$BASE_DIR/generated"

# Clean up existing generated answers
rm -rf "$OUTPUT_DIR"

# Arrays for providers, actions, and apps.
PROVIDERS=(aws openshift plain gcp)
ACTIONS=(clean install upgrade)
APPS=(deploy release)

for provider in "${PROVIDERS[@]}"; do
  mkdir -p "$OUTPUT_DIR/$provider"

  for action in "${ACTIONS[@]}"; do
    for app in "${APPS[@]}"; do
      # Define the three input YAML files.
      base_file="$TEMPLATE_DIR/apps/${app}/${app}-basic.yaml"
      action_file="$TEMPLATE_DIR/apps/${app}/${app}-basic-${action}.yaml"
      provider_file="$TEMPLATE_DIR/providers/${provider}/${app}-basic-${action}.yaml"
      
      # Define the output file.
      output_file="$OUTPUT_DIR/${provider}/${app}-basic-${action}.yaml"
      
      # For each file, if it does not exist then supply an empty YAML document "{}".
      if [ -f "$base_file" ]; then
        b="$base_file"
      else
        b=<(echo "{}")
      fi

      if [ -f "$action_file" ]; then
        a="$action_file"
      else
        a=<(echo "{}")
      fi

      if [ -f "$provider_file" ]; then
        p="$provider_file"
      else
        p=<(echo "{}")
      fi

      # Merge the three YAML documents.
      # The merge operator (*) in yq applies left-to-right so that keys from later files override earlier ones.
      if yq eval-all 'select(fileIndex == 0) * select(fileIndex == 1) * select(fileIndex == 2)' "$b" "$a" "$p" > "$output_file" 2>/tmp/yq_err; then
        echo "Generated $output_file"
      else
        echo "ERROR: Failed to generate $output_file" >&2
        echo "  base:     $base_file (exists: $([ -f "$base_file" ] && echo yes || echo no))" >&2
        echo "  action:   $action_file (exists: $([ -f "$action_file" ] && echo yes || echo no))" >&2
        echo "  provider: $provider_file (exists: $([ -f "$provider_file" ] && echo yes || echo no))" >&2
        echo "  yq error: $(cat /tmp/yq_err)" >&2
      fi
    done
  done
done
