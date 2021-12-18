import 'package:flutter/material.dart';
import '../font.dart';

class Banner extends StatelessWidget {
  const Banner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 1.0),
          colors: <Color>[
            const Color(0xFf3366FF),
            const Color(0xFF00CCff),
          ],
          stops: <double>[0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(25),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Big 5 개발자 채용 공고",
                    style: TextStyle(
                        fontSize: 35,
                        fontFamily: MyFontFamily.eliceBold,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  Text(
                    "여기 다 모아 놨어!",
                    style: TextStyle(
                        fontSize: 50,
                        fontFamily: MyFontFamily.eliceBold,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image.asset(
                'assets/search.png',
                width: 250,
                fit: BoxFit.fitWidth,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      // child: Stack(fit: StackFit.loose, children: [
      //   Positioned.fill(
      //     child: Align(
      //       alignment: Alignment.center,
      //       child: Image.asset(
      //         'assets/background.jpg',
      //         width: double.infinity,
      //         height: 200,
      //         fit: BoxFit.fill,
      //       ),
      //     ),
      //   ),
      //   Positioned.fill(
      //     child: Align(
      //       alignment: Alignment.center,
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: const [
      //           Text(
      //             "Top 7 채용 공고\n 모아 놓음",
      //             style: TextStyle(
      //                 fontSize: 25,
      //                 fontWeight: FontWeight.bold,
      //                 color: Colors.white),
      //           ),
      //         ],
      //       ),
      //     ),
      //   )
      // ]),
    );
  }
}
