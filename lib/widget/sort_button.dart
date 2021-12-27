import 'package:devmaan_newflutter/main.dart';
import 'package:flutter/material.dart';

class SortButton extends StatefulWidget {
  void Function(SortBy) onTap;
  SortBy sortType;

  SortButton({
    Key? key,
    required this.onTap,
    required this.sortType,
  }) : super(key: key);

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  bool isTapped = false;

  String getString(SortBy sortType) {
    switch (sortType) {
      case SortBy.year:
        return "경력순";
      case SortBy.date:
        return "마감일순";
      default:
        return "알 수 없음";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          isTapped = isTapped ? false : true;
          widget.onTap(widget.sortType);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              Colors.blue.withOpacity(isTapped ? 1 : 0)),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Icon(Icons.air, size: 13),
              SizedBox(width: 5),
              Text(
                getString(widget.sortType),
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
        ));
  }
}
