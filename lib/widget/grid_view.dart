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
    return Container(
      width: 850,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ResponsiveGridList(
            desiredItemWidth: 230,
            minSpacing: 20,
            scroll: false,
            children:
                _notices.map((notice) => NoticeItem(notice: notice)).toList(),
          )
        ],
      ),
    );
  }
}
