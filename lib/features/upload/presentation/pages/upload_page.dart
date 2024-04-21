import 'package:flutter/material.dart';
import 'package:pedalpulse/core/common/providers/app_size_provider.dart';
import 'package:pedalpulse/features/auth/presentation/widgets/custom_text_button_widget.dart';

import '../../../../injection_container.dart';
import '../../../../utils/managers/string_manager.dart';
import '../../../../widgets/loading_placeholder_widget.dart';
import '../providers/upload_provider.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = getIt<AppSizeProvider>().size;
    final double tileWidth = (size.width - 16) / 3;
    final double cardWidth = size.width / 2 - 16;

    final UploadProvider uploadProvider = getIt<UploadProvider>();

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text(AppStringManager.uploadPost),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: uploadProvider.isLoading
                ? const LoadingPlaceholderWidget(size: 30)
                : CustomTextButtonWidget(
                    placeholder: AppStringManager.postUppercase,
                    onTap: uploadProvider.upload,
                  ),
          )
        ],
      ),
      body: const Center(
        child: Text('Upload Page'),
      ),
    );
  }
}
