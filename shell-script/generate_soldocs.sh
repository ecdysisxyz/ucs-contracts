#!/usr/bin/env sh

set -e  # Exit immediately if a command exits with a non-zero status.

# Source the index utilities
. "$(dirname "$0")/soldocs/generate_and_move_forge_docs.sh"
. "$(dirname "$0")/soldocs/generate_index.sh"
. "$(dirname "$0")/soldocs/convert_links.sh"

# Main function
main() {
    # Generate and Move forge docs
    generate_and_move_forge_docs

    # Generate index files: process directories
    generate_index docs/02-proxy/01-api-reference/
    generate_index docs/03-dictionary/01-api-reference/

    # Convert links
    convert_links

    echo "Successfully generated Solidity API docs and processed $(find docs -type f | wc -l) files!"
}

# Run the main function
main
