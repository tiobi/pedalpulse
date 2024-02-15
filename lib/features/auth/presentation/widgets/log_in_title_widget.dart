import 'package:flutter/cupertino.dart';
import '../../../../utils/managers/asset_manager.dart';

class LogInTitleWidget extends StatelessWidget {
  const LogInTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Center(
      child: Container(
        margin: EdgeInsets.only(top: height * 0.05),
        width: width - 20,
        height: 150,
        child: Image.asset(
          ImageAssetManager.appLogoColor,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
