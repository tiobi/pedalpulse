import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/widgets/custom_textfield_widget.dart';
import '../../../../core/common/managers/string_manager.dart';
import '../../../../core/common/widgets/custom_dynamic_height_textfield_widget.dart';
import '../../../../core/common/widgets/loading_placeholder_widget.dart';
import '../../../../core/common/widgets/snack_bar_widget.dart';
import '../../../auth/presentation/widgets/custom_text_button_widget.dart';
import '../providers/request_provider.dart';

class RequestPage extends HookWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RequestProvider requestProvider =
        Provider.of<RequestProvider>(context);

    final TextEditingController manufacturerController =
        useTextEditingController();
    final TextEditingController modelController = useTextEditingController();
    final TextEditingController descriptionController =
        useTextEditingController();

    void onSendRequest() async {
      if (manufacturerController.text.isEmpty ||
          modelController.text.isEmpty ||
          descriptionController.text.isEmpty) {
        CustomSnackBar.showErrorSnackBar(
          context,
          AppStringManager.fillInTheFields,
        );
        return;
      }

      await requestProvider.sendRequest(
        manufacturer: manufacturerController.text,
        model: modelController.text,
        description: descriptionController.text,
      );

      Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(AppStringManager.sendRequest),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: requestProvider.isLoading
                ? const LoadingPlaceholderWidget(size: 30)
                : CustomTextButtonWidget(
                    placeholder: AppStringManager.send,
                    onTap: onSendRequest,
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
              controller: manufacturerController,
            ),
            CustomTextfieldWidget(
              placeholder: AppStringManager.model,
              controller: modelController,
            ),
            CustomDynamicHeightTextfieldWidget(
              textController: descriptionController,
              maxLength: 500,
              placeholder: AppStringManager.description,
            ),
          ],
        ),
      ),
    );
  }
}
