import 'package:flutter/material.dart';
import './company_list.dart';
import '../model/notice.dart';

class CompanyItem extends StatefulWidget {
  CompanyItem({
    Key? key,
    required this.company,
    required this.widget,
    required this.isSelected,
  }) : super(key: key);

  final Company company;
  final CompanyList widget;
  final bool isSelected;

  @override
  State<CompanyItem> createState() => _CompanyItemState();
}

class _CompanyItemState extends State<CompanyItem> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    const _minimumWindowSize = 800;
    bool isLine = widget.company.getName() == 'Line';

    double responsiveSize(double size) {
      return queryData.size.width < _minimumWindowSize
          ? size * queryData.size.width / _minimumWindowSize
          : size;
    }

    return Row(
      children: [
        InkWell(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              transform: isHovering
                  ? (Matrix4.identity()..translate(0, -10, 0))
                  : Matrix4.identity(),
              child: Row(
                children: [
                  Image.asset(
                    'images/' + widget.company.getName().toLowerCase() + '.png',
                    width: responsiveSize(isLine ? 60 : 80),
                    fit: BoxFit.fitWidth,
                  ),
                  if (widget.isSelected) ...[
                    Padding(
                      padding: EdgeInsets.only(top: responsiveSize(30)),
                      child: Column(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: responsiveSize(15)),
                          Spacer(),
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),
          ),
          onTap: () {
            widget.widget.onTap(widget.company);
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
        ),
        SizedBox(width: 20)
      ],
    );
  }
}
