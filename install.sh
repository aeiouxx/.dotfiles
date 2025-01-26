#!/bin/bash
# Check if XDG_CONFIG_HOME is set, optionally set it
if [ -z "$XDG_CONFIG_HOME" ]; then
    echo "==============================================="
    echo "WARNING: The XDG_CONFIG_HOME environment variable is not set."
    echo "This variable defines the base directory relative to which"
    echo "user-specific configuration files should be stored."
    echo "Would you like to set it to \$HOME/.config?"
    echo "==============================================="
    
    read -p "Enter your choice (Y = Yes, N = No): " choice
    case "$choice" in
        [Yy]* )
            echo "Setting XDG_CONFIG_HOME to \$HOME/.config..."
            export XDG_CONFIG_HOME="$HOME/.config"
            echo "export XDG_CONFIG_HOME=\"$HOME/.config\"" >> ~/.bashrc
            echo "XDG_CONFIG_HOME has been set successfully."
            ;;
        [Nn]* )
            echo "You chose not to set the XDG_CONFIG_HOME variable."
            echo "The script cannot continue without this setting."
            echo "Exiting the script..."
            exit 1
            ;;
        * )
            echo "Invalid input. Exiting the script..."
            exit 1
            ;;
    esac
fi

# Set the source directory (adjust this to your dotfiles location)
SOURCE_DIR="$(dirname "$(readlink -f "$0")")/.config"

# Set the target directory
TARGET_DIR="$XDG_CONFIG_HOME"

# Ensure the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

# Sync files from source to target, excluding .git
rsync -av --exclude=".git" "$SOURCE_DIR/" "$TARGET_DIR/"

# Confirmation
