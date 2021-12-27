import 'package:devmaan_newflutter/font.dart';

import '../model/notice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class NoticeItem extends StatefulWidget {
  const NoticeItem({
    Key? key,
    required this.notice,
  }) : super(key: key);

  final Notice notice;

  @override
  State<NoticeItem> createState() => _NoticeItemState();
}

class _NoticeItemState extends State<NoticeItem> {
  double scale = 1.0;
  bool isHovering = false;

  void _openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  String getDateString(Notice notice) {
    String result;
    if (notice.parsedDate[0].year == 9999) {
      result = "영입 종료 시";
    } else {
      DateFormat outFormat = DateFormat('yyyy.MM.dd');
      result =
          "${outFormat.format((notice.parsedDate[0]))} ~ ${outFormat.format((notice.parsedDate[1]))}";
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Widget card = Card(
      elevation: isHovering ? 15 : 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: AutoSizeText(
                // 공고 제목
                widget.notice.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: MyFontFamily.nanumBold,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 15),
            // 로고
            Image.asset(
              'images/' +
                  widget.notice.company.getName().toLowerCase() +
                  '.png',
              width: 70,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 5),

            // 날짜
            Text(
              getDateString(widget.notice),
              style: const TextStyle(
                fontSize: 13,
                fontFamily: MyFontFamily.nanumRegular,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),

            Spacer(),

            // 태그 박스
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Center(
                        child: Text(
                          widget.notice.year.getStrYear(),
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );

    return InkWell(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          height: 230,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  spreadRadius: 5,
                  color: Colors.grey.withOpacity(0.4),
                )
              ],
            ),
            child: card,
          ),
        ),
      ),
      onTap: () {
        print("SSS");
        _openUrl(widget.notice.link);
      },
      onHover: (on) {
        if (on) {
          setState(() {
            isHovering = true;
          });
        } else {
          setState(() {
            isHovering = false;
            on = false;
          });
        }
      },
    );
  }
}
