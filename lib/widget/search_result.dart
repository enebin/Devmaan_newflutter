import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class SearchResult extends StatelessWidget {
  SearchResult({
    Key? key,
    required this.onTap,
    required this.submittedText,
    required this.resultLength,
    this.isRowType = false,
  }) : super(key: key);

  VoidCallback onTap;
  String submittedText;
  int resultLength;
  bool isRowType;

  @override
  Widget build(BuildContext context) {
    // 검색 결과 개수
    Widget searchResult = AutoSizeText(
      "검색결과 $resultLength개",
      maxLines: 1,
      style: TextStyle(color: Colors.grey, fontSize: isRowType ? 6 : 12),
    );

    // 크기에 따라 row col 다른 컨텐츠 리턴 목적
    Widget content = ElevatedButton(
      style: ButtonStyle(
        shadowColor: MaterialStateProperty.all(Colors.white.withOpacity(1)),
        backgroundColor:
            MaterialStateProperty.all(Colors.white.withOpacity(0.5)),
      ),
      onPressed: () => onTap(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Icons.cancel,
            size: isRowType ? 10 : 12,
            color: Colors.black,
          ),
          SizedBox(width: 8),
          searchResult
          // AutoSizeText(
          //   submittedText,
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontSize: isRowType ? 7 : 14,
          //   ),
          // ),
        ],
      ),
    );

    // Widget columnType = Column(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   children: [
    //     content,
    //   ],
    // );

    // Widget rowType = Row(
    //   // 주로 모바일용으로 쓰일 것이므로 작게 만들자
    //   children: [
    //     content,
    //   ],
    // );

    return content;
  }
}
