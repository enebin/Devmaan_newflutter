import 'package:flutter/material.dart';
import '../font.dart';

class Banner extends StatelessWidget {
  const Banner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget TextAndImage = Row(
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
    );
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
        padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Stack(
            children: [
              TextAndImage,
              Positioned.fill(
                  child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Container(
                      child: Text("원하는 회사만 골라서 볼 수 있어요!",
                          style: TextStyle(
                            fontFamily: MyFontFamily.eliceBold,
                            fontWeight: FontWeight.bold,
                          )),
                    )),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
