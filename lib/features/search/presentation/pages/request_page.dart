import 'package:flutter/material.dart';

import '../../../../core/common/widgets/custom_textfield_widget.dart';
import '../../../../utils/managers/string_manager.dart';
import '../../../../core/common/widgets/custom_dynamic_height_textfield_widget.dart';
import '../../../../widgets/loading_placeholder_widget.dart';
import '../../../auth/presentation/widgets/custom_text_button_widget.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(AppStringManager.sendRequest),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: false
                ? LoadingPlaceholderWidget(size: 30)
                : CustomTextButtonWidget(
                    placeholder: AppStringManager.send,
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
            ),
            CustomTextfieldWidget(
              placeholder: AppStringManager.model,
            ),
            CustomDynamicHeightTextfieldWidget(
              textController: TextEditingController(),
              maxLength: 500,
              placeholder: AppStringManager.description,
            ),
          ],
        ),
      ),
    );
  }
}
