import 'package:flutter/material.dart';

class SortButton extends StatefulWidget {
  VoidCallback onTap;
  Color color;
  String text;

  SortButton({
    Key? key,
    required this.onTap,
    required this.color,
    required this.text,
  }) : super(key: key);

  @override
  State<SortButton> createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          widget.onTap();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(widget.color),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
        ),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              // Icon(Icons.air, size: 13),
              // SizedBox(width: 5),
              Text(
                widget.text,
                style: TextStyle(fontSize: 13),
              )
            ],
          ),
        ));
  }
}
