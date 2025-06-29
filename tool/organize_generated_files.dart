#!/usr/bin/env dart

import 'dart:io';
import 'dart:async';

/// Script to organize generated Freezed files into .g/entity_name.dart structure
/// This script combines .freezed.dart and .g.dart files into a single .g/entity_name.dart file
Future<void> main() async {
  print('🔄 Organizing generated files into .g directories...');

  final libDir = Directory('lib');
  if (!await libDir.exists()) {
    print('❌ Error: lib directory not found');
    exit(1);
  }

  // Find all .freezed.dart and .g.dart files
  final generatedFiles = <String, Map<String, File>>{};
  
  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File) {
      final path = entity.path;
      if (path.endsWith('.freezed.dart') || path.endsWith('.g.dart')) {
        final directory = entity.parent.path;
        final filename = entity.uri.pathSegments.last;
        
        String baseName;
        String type;
        
        if (filename.endsWith('.freezed.dart')) {
          baseName = filename.replaceAll('.freezed.dart', '');
          type = 'freezed';
        } else {
          baseName = filename.replaceAll('.g.dart', '');
          type = 'json';
        }
        
        final key = '$directory/$baseName';
        generatedFiles.putIfAbsent(key, () => <String, File>{});
        generatedFiles[key]![type] = entity;
      }
    }
  }

  if (generatedFiles.isEmpty) {
    print('ℹ️  No generated files found to organize');
    return;
  }

  // Process each entity's files
  for (final entry in generatedFiles.entries) {
    final keyParts = entry.key.split('/');
    final directory = keyParts.sublist(0, keyParts.length - 1).join('/');
    final baseName = keyParts.last;
    final files = entry.value;
    
    print('📁 Processing $baseName...');
    
    // Create .g directory
    final gDirectory = Directory('$directory/.g');
    await gDirectory.create(recursive: true);
    
    // Create target file
    final targetFile = File('${gDirectory.path}/$baseName.dart');
    final buffer = StringBuffer();
    
    // Add header
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND');
    buffer.writeln('// This file contains generated code for $baseName');
    buffer.writeln('// Combined from Freezed and JSON serialization generators');
    buffer.writeln('');
    
    // Add freezed content first
    if (files.containsKey('freezed')) {
      final freezedContent = await files['freezed']!.readAsString();
      buffer.writeln('// Freezed Code');
      buffer.writeln('');
      buffer.write(freezedContent);
      buffer.writeln('');
      
      // Delete original freezed file
      await files['freezed']!.delete();
    }
    
    // Add JSON serialization content
    if (files.containsKey('json')) {
      buffer.writeln('// JSON Serialization Code');
      buffer.writeln('');
      final jsonContent = await files['json']!.readAsString();
      buffer.write(jsonContent);
      
      // Delete original json file
      await files['json']!.delete();
    }
    
    // Write combined content to target file
    await targetFile.writeAsString(buffer.toString());
  }

  print('✅ Generated files organized successfully!');
  print('');
  print('📋 Generated file structure:');
  
  // List organized files
  await for (final entity in libDir.list(recursive: true)) {
    if (entity is Directory && entity.path.endsWith('/.g')) {
      print('  ${entity.path}/');
      await for (final file in entity.list()) {
        if (file is File && file.path.endsWith('.dart')) {
          final fileName = file.uri.pathSegments.last;
          print('    $fileName');
        }
      }
    }
  }
  
  print('');
  print('🎯 All generated files are now organized in .g/entity_name.dart format');
}