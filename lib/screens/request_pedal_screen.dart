// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../models/pedal_model.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';
import '../services/firebase/pedal_firestore_methods.dart';
import '../utils/managers/message_manager.dart';
import '../utils/managers/string_manager.dart';
import '../widgets/custom_dynamic_height_textfield_widget.dart';
import '../features/auth/presentation/widgets/custom_text_button_widget.dart';
import '../features/auth/presentation/widgets/custom_textfield_widget.dart';
import '../widgets/loading_placeholder_widget.dart';

import 'package:provider/provider.dart';

class RequestPedalScreen extends StatefulWidget {
  final PedalModel? pedal;
  const RequestPedalScreen({
    Key? key,
    this.pedal,
  }) : super(key: key);

  @override
  _RequestPedalScreenState createState() => _RequestPedalScreenState();
}

class _RequestPedalScreenState extends State<RequestPedalScreen> {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.pedal != null) {
      _brandController.text = widget.pedal!.brand;
      _modelController.text = widget.pedal!.name;
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void onSend() async {
    toggleLoading();
    final UserModel? user =
        Provider.of<UserProvider>(context, listen: false).user;

    if (_brandController.text.isEmpty || _modelController.text.isEmpty) {
      // show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStringManager.fillInTheFields),
        ),
      );

      toggleLoading();

      return;
    }

    final String message = await PedalFirestoreMethods().sendPedalRequest(
      brand: _brandController.text,
      name: _modelController.text,
      description: _descriptionController.text,
      user: user!,
    );

    toggleLoading();

    if (message == NetworkMessageManager.success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStringManager.requestSentSuccessfully),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(AppStringManager.sendRequest),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? const LoadingPlaceholderWidget(size: 30)
                : CustomTextButtonWidget(
                    placeholder: AppStringManager.send,
                    onTap: onSend,
                  ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextfieldWidget(
                placeholder: AppStringManager.manufacturer,
                controller: _brandController),
            CustomTextfieldWidget(
                placeholder: AppStringManager.model,
                controller: _modelController),
            CustomDynamicHeightTextfieldWidget(
              textController: _descriptionController,
              maxLength: 500,
              placeholder: AppStringManager.description,
            ),
          ],
        ),
      ),
    );
  }
}
