import 'package:devmaan_newflutter/font.dart';

import '../model/notice.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

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
              child: Text(
                widget.notice.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: MyFontFamily.nanumBold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            Image.asset(
              'assets/' +
                  widget.notice.company.getName().toLowerCase() +
                  '.png',
              width: 70,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 5),
            Container(
              padding: EdgeInsets.all(10),
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
            Spacer(),
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
