import 'package:flutter/material.dart';

import './search_result.dart';
import '../util.dart';

class SearchTextField extends StatefulWidget {
  SearchTextField({
    Key? key,
    required this.onSubmit,
    required this.onDismiss,
    required this.submittedText,
    required this.length,
  }) : super(key: key);

  void Function(String) onSubmit;
  VoidCallback onDismiss;
  String submittedText;
  int length;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool _isFocused = false;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var size = MediaQuery.of(context).size;
    const _minimumWindowSize = 800;
    bool isMobile = Util.mobileScreenSize > size.width;
    bool isMedium = _minimumWindowSize > size.width;

    double responsiveSize(double size) {
      return queryData.size.width < _minimumWindowSize
          ? size * queryData.size.width / _minimumWindowSize
          : size;
    }

    void _submitHandler(String text) {
      widget.onSubmit(text);
    }

    void _resultHandler() {
      setState(() {
        widget.onSubmit("");
        widget.onDismiss;
        textController.text = "";
        widget.submittedText = "";
      });
    }

    var SearchBar = Container(
      width: isMobile ? 250 : responsiveSize(450),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                spreadRadius: _isFocused ? 3 : 1,
                color: Colors.grey.withOpacity(0.5),
                offset: const Offset(0, 3)),
          ]),
      child: Focus(
        child: TextField(
          onSubmitted: (text) {
            _submitHandler(text);
          },
          keyboardType: TextInputType.text,
          controller: textController,
          decoration: InputDecoration(
            fillColor: Colors.white,
            hoverColor: Colors.grey,
            hintText: "채용 공고 검색",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
            border: InputBorder.none,
            icon: const Padding(
              padding: EdgeInsets.only(left: 13),
              child: Icon(Icons.snowboarding, size: 15),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                _submitHandler(textController.text);
              },
              icon: Icon(Icons.search_rounded, size: 16, color: Colors.blue),
            ),
          ),
        ),
        onFocusChange: (status) {
          if (status) {
            setState(() {
              textController.text = "";
              _isFocused = true;
            });
          } else {
            setState(() {
              _isFocused = false;
            });
          }
        },
      ),
    );

    Widget stackType = Stack(
      // 검색창에 행으로 겹치는 타입
      children: [
        Positioned(
          child: Align(
            // 검색창
            alignment: Alignment.center,
            child: SearchBar,
          ),
        ),
        if (widget.submittedText != "" && isMobile == false) ...[
          // 검색 상태 및 결과 -> 크기가 작거나 검색한 것이 없으면 안 보인다.
          Positioned(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                  width: responsiveSize(150),
                  padding: EdgeInsets.only(right: responsiveSize(25)),
                  child: SearchResult(
                    onTap: _resultHandler,
                    resultLength: widget.length,
                    submittedText: widget.submittedText,
                  )),
            ),
          )
        ]
      ],
    );

    Widget columnType = Column(children: [
      // 검색창과 위아래로 쌓는 타입
      SearchBar,
      SizedBox(height: 7),
      if (widget.submittedText != "") ...[
        // 검색 상태 및 결과 -> 크기가 작거나 검색한 것이 없으면 안 보인다.
        Container(
          width: 130,
          // padding: EdgeInsets.only(right: 25),
          child: SearchResult(
            onTap: _resultHandler,
            resultLength: widget.length,
            submittedText: widget.submittedText,
            isRowType: true,
          ),
        ),
      ],
    ]);

    return Container(
      padding: EdgeInsets.only(top: 25),
      child: isMedium ? columnType : stackType,
    );
  }
}
