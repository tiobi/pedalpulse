#!/bin/bash

# Script to organize generated Freezed files into .g/entity_name.dart structure
# This script combines .freezed.dart and .g.dart files into a single .g/entity_name.dart file

echo "🔄 Organizing generated files into .g directories..."

# Find all .freezed.dart and .g.dart files in lib directory
find lib -name "*.freezed.dart" -o -name "*.g.dart" | sort | while read file; do
    dir=$(dirname "$file")
    filename=$(basename "$file")
    
    # Extract the base name (entity name) from the file
    if [[ "$filename" == *.freezed.dart ]]; then
        base=$(echo "$filename" | sed 's/\.freezed\.dart$//')
        type="freezed"
    elif [[ "$filename" == *.g.dart ]]; then
        base=$(echo "$filename" | sed 's/\.g\.dart$//')
        type="json"
    else
        continue
    fi
    
    # Create .g directory if it doesn't exist
    mkdir -p "$dir/.g"
    
    target_file="$dir/.g/${base}.dart"
    
    # If this is the first file for this entity, start fresh
    if [[ "$type" == "freezed" ]]; then
        echo "📁 Processing $base..."
        
        # Start with a header comment
        cat > "$target_file" << EOF
// GENERATED CODE - DO NOT MODIFY BY HAND
// This file contains generated code for $base
// Generated from: ${file#lib/}

EOF
        
        # Add the freezed content
        cat "$file" >> "$target_file"
        
        # Add separator for JSON content
        echo "" >> "$target_file"
        echo "// JSON Serialization Code" >> "$target_file"
        echo "" >> "$target_file"
        
    elif [[ "$type" == "json" ]] && [[ -f "$target_file" ]]; then
        # Append JSON serialization content
        cat "$file" >> "$target_file"
    elif [[ "$type" == "json" ]] && [[ ! -f "$target_file" ]]; then
        # If only JSON file exists (shouldn't happen with Freezed, but just in case)
        echo "📁 Processing $base (JSON only)..."
        cat > "$target_file" << EOF
// GENERATED CODE - DO NOT MODIFY BY HAND
// This file contains generated code for $base
// Generated from: ${file#lib/}

EOF
        cat "$file" >> "$target_file"
    fi
    
    # Remove the original file
    rm "$file"
done

echo "✅ Generated files organized successfully!"
echo ""
echo "📋 Generated file structure:"
find lib -name ".g" -type d | while read dir; do
    echo "  $dir/"
    ls -la "$dir" | grep "\.dart$" | awk '{print "    " $9}'
done

echo ""
echo "🎯 All generated files are now organized in .g/entity_name.dart format"