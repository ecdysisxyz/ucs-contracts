#!/usr/bin/env sh

set -e  # Exit immediately if a command exits with a non-zero status.

# Generate solidity docs using `forge doc``
generate_forge_docs() {
    forge doc -o soldocs/ || { echo "Failed to generate solidity docs"; exit 1; }
}

# Move generated docs to appropriate directories
move_forge_docs() {
    cp -r soldocs/src/src/proxy/ docs/02-proxy/01-api-reference/ || { echo "Failed to move proxy docs"; exit 1; }
    cp -r soldocs/src/src/dictionary/ docs/03-dictionary/01-api-reference/ || { echo "Failed to move dictionary docs"; exit 1; }
}

# Remove unnecessary soldocs/
remove_forge_docs() {
    rm -rf soldocs
}

# Main function
generate_and_move_forge_docs() {
    generate_forge_docs
    move_forge_docs
    remove_forge_docs
}

# Use the function if this script is run directly
if [ "$(basename "$0")" = "generate_and_move_forge_docs.sh" ]; then
    generate_and_move_forge_docs
fi
