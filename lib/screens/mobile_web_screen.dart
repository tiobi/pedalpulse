import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/managers/asset_manager.dart';
import '../features/auth/presentation/widgets/log_in_title_widget.dart';
import '../utils/managers/string_manager.dart';
import '../features/auth/presentation/widgets/custom_text_button_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class MobileWebScreen extends StatelessWidget {
  const MobileWebScreen({Key? key}) : super(key: key);

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw WebStringManager.launchUrlError;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Column(
          children: [
            const LogInTitleWidget(),
            const Expanded(
              child: Center(
                child: Text(
                  WebStringManager.availableOn,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    _launchUrl(WebStringManager.appStoreUrl);
                  },
                  child: SvgPicture.asset(
                    ImageAssetManager.appStoreBadge,
                    height: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launchUrl(WebStringManager.playStoreUrl);
                  },
                  child: Image.asset(
                    ImageAssetManager.googlePlayBadge,
                    height: 80,
                  ),
                ),
              ],
            ),
            const Spacer(),
            CustomTextButtonWidget(
                placeholder: WebStringManager.privacyPolicy,
                onTap: () {
                  _launchUrl(WebStringManager.privacyPolicyUrl);
                }),
            CustomTextButtonWidget(
              placeholder: WebStringManager.termsOfService,
              onTap: () {
                _launchUrl(WebStringManager.termsOfServiceUrl);
              },
            ),
            const SizedBox(height: 50),
            const Text(WebStringManager.contact),
            const SizedBox(height: 20),
            // IconButton(
            //   onPressed: () {
            //     Navigator.of(context).pushNamed(Routes.addPost);
            //   },
            //   icon: const Icon(Icons.add),
            // ),
          ],
        ),
      ),
    );
  }
}
