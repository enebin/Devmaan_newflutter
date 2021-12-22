import 'package:flutter/material.dart';
import '../font.dart';

import 'package:auto_size_text/auto_size_text.dart';

class Banner extends StatelessWidget {
  const Banner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    const _minimumWindowSize = 800;

    double responsiveSize(double size) {
      return queryData.size.width < _minimumWindowSize
          ? size * queryData.size.width / _minimumWindowSize
          : size;
    }

    Widget TextAndImage = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                "Big 5 개발자 채용 공고",
                style: TextStyle(
                    fontSize: responsiveSize(35),
                    fontFamily: MyFontFamily.eliceBold,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                maxLines: 1,
              ),
              AutoSizeText(
                "여기 다 모아 놨어!",
                style: TextStyle(
                    fontSize: responsiveSize(50),
                    fontFamily: MyFontFamily.eliceBold,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
                maxLines: 1,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Image.asset(
            'images/search.png',
            width: queryData.size.width < _minimumWindowSize ? 0 : 250,
            fit: BoxFit.fitWidth,
          ),
        ),
        // const Spacer(),
      ],
    );

    Widget Info = Positioned(
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: AutoSizeText(
                "원하는 회사만 골라서 볼 수 있어요!",
                style: TextStyle(
                  fontFamily: MyFontFamily.eliceBold,
                  fontWeight: FontWeight.bold,
                  fontSize: responsiveSize(15),
                ),
                maxLines: 1,
              ),
            )),
      ),
    );

    // 배너
    return Container(
      height: responsiveSize(400),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 1.0),
          colors: <Color>[
            Color(0xFf3366FF),
            Color(0xFF00CCff),
          ],
          stops: <double>[0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Container(
        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: Stack(
          children: [
            TextAndImage,
            Info,
          ],
        ),
      ),
    );
  }
}
