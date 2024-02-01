import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<XFile>? _imageFiles;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _categoriesController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String datails = 'no datails';

  Future<void> _pickImages() async {
    List<XFile>? images = await _picker.pickMultiImage(
      imageQuality: 25,
    );
    setState(() {
      _imageFiles = images;
    });
  }

  void _reset() {
    setState(() {
      _imageFiles = null;
      _nameController.clear();
      _brandController.clear();
      _categoriesController.clear();
      _descriptionController.clear();
    });
  }

  // void _uploadData() async {
  //   // implement image compression
  //   // with flutter_image_compress

  //   final message = await PedalFirestoreMethods().uploadPedalData(
  //     name: _nameController.text,
  //     brand: _brandController.text,
  //     description: _descriptionController.text,
  //     category: capitalizeCategories(_categoriesController.text),
  //     images: _imageFiles!,
  //   );
  //   if (message == NetworkMessageManager.success) {
  //     _reset();
  //   }
  // }

  void getFileName(String fileName) {
    // Remove ".png" extension if present
    if (fileName.endsWith('.png')) {
      fileName = fileName.substring(0, fileName.length - 4);
    }

    // Split the fileName by "-"
    List<String> nameParts = fileName.split('-');

    if (nameParts.isNotEmpty) {
      String brand = capitalizeWords(nameParts[0]);
      String name = capitalizeWords(nameParts.sublist(1).join(' '));

      // Set _brandController and _nameController values
      _brandController.text = brand;
      _nameController.text = name;
      _categoriesController.text = 'Multi-Effects';
    }
  }

  List<String> capitalizeCategories(String input) {
    List<String> categories = input.replaceAll(" ", '').split(',');
    List<String> capitalizedCategories = [];

    for (String category in categories) {
      capitalizedCategories.add(capitalize(category));
    }

    return capitalizedCategories;
  }

  String capitalizeWords(String input) {
    if (input.isEmpty) return input;

    List<String> words = input.split(' ');
    List<String> capitalizedWords = [];

    for (String word in words) {
      capitalizedWords.add(capitalize(word));
    }

    return capitalizedWords.join(' ');
  }

  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropTarget(
              onDragDone: (details) {
                getFileName(details.files.first.name);
                setState(() {
                  _imageFiles = details.files.reversed.toList();
                  datails = details.files.first.name;
                });
              },
              child: Container(
                color: Colors.amber,
                height: 200,
                width: 500,
              ),
            ),
            _buildImagePreview(),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(labelText: 'Brand'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 5,
              onSubmitted: (_) {},
            ),
            TextField(
              controller: _categoriesController,
              decoration: const InputDecoration(labelText: 'Categories'),
              onSubmitted: (value) {
                // _uploadData();
              },
            ),
            const SizedBox(height: 20),

            const ElevatedButton(
              // onPressed: _uploadData,
              onPressed: null,
              child: Text('Upload Data to Firebase'),
            ),
            // Make a reset button
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _reset,
              child: const Text('Reset'),
            ),

            const ElevatedButton(
              onPressed: null,
              child: Text('Get File Name'),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageFiles == null || _imageFiles!.isEmpty) {
      return Container(); // Placeholder for no images selected.
    } else {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? 4 : 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: _imageFiles!.length,
        itemBuilder: (context, index) {
          return _imageFiles!.isEmpty
              ? Container(
                  height: 200,
                )
              : Image.network(
                  _imageFiles![index].path,
                  height: 200,
                  width: 100,
                  fit: BoxFit.contain,
                );
        },
      );
    }
  }
}
