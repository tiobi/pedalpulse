import 'package:flutter/material.dart';

class RequestProvider extends ChangeNotifier {
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  TextEditingController get manufacturerController => _manufacturerController;
  TextEditingController get modelController => _modelController;
  TextEditingController get descriptionController => _descriptionController;

  Future<void> sendRequest() async {}
}
