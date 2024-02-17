import 'package:flutter/cupertino.dart';
import '../../../../utils/managers/asset_manager.dart';

class SignInTitleWidget extends StatelessWidget {
  const SignInTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final width = size.width;

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        width: width - 20,
        child: Image.asset(
          ImageAssetManager.appLogoColor,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
