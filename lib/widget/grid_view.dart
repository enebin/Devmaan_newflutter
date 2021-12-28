import 'package:devmaan_newflutter/util.dart';
import 'package:flutter/material.dart';

import 'package:responsive_grid/responsive_grid.dart';

import 'package:devmaan_newflutter/model/notice.dart';
import './grid_item.dart';

class GridView extends StatelessWidget {
  const GridView({
    Key? key,
    required List<Notice> notices,
  })  : _notices = notices,
        super(key: key);

  final List<Notice> _notices;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isMobile = Util.mobileScreenSize > size.width;

    return Container(
      width: isMobile ? size.width * 0.9 : size.width * 0.75,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isMobile) ...[
            ResponsiveGridList(
              desiredItemWidth: 90,
              minSpacing: isMobile ? 10 : 20,
              scroll: false,
              children:
                  _notices.map((notice) => NoticeItem(notice: notice)).toList(),
            )
          ] else ...[
            ResponsiveGridList(
              desiredItemWidth: 200,
              minSpacing: 20,
              scroll: false,
              children:
                  _notices.map((notice) => NoticeItem(notice: notice)).toList(),
            )
          ]
        ],
      ),
    );
  }
}
