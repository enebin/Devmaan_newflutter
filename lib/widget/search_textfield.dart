import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../util.dart';

class SearchTextField extends StatefulWidget {
  SearchTextField({
    Key? key,
    required this.onSubmit,
    required this.onDismiss,
    required this.submitted,
    required this.length,
  }) : super(key: key);

  void Function(String) onSubmit;
  VoidCallback onDismiss;
  String submitted;
  int length;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool _isFocused = false;
  TextEditingController textController = TextEditingController();

  void _submitHandler(String text) {
    widget.onSubmit(text);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var size = MediaQuery.of(context).size;
    const _minimumWindowSize = 800;
    bool isMobile = Util.mobileScreenSize > size.width;

    double responsiveSize(double size) {
      return queryData.size.width < _minimumWindowSize
          ? size * queryData.size.width / _minimumWindowSize
          : size;
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
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: Stack(
        children: [
          Positioned(
            child: Align(
              alignment: Alignment.center,
              child: SearchBar,
            ),
          ),
          if (widget.submitted != "") ...[ // 검색 상태
            Positioned(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: responsiveSize(150),
                  padding: EdgeInsets.only(right: 25),
                  child: SearchResult()
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}


class SearchResult extends StatelessWidget {
  const SearchResult({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          shadowColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(1)),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.white.withOpacity(0.5)),
                        ),
                        onPressed: () {
                          setState(() {
                            widget.onSubmit("");
                            widget.onDismiss;
                            textController.text = "";
                            widget.submitted = "";
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.cancel,
                              size: 12,
                              color: Colors.black,
                            ),
                            AutoSizeText(
                              widget.submitted,
                              style: TextStyle(color: Colors.black),
                              maxFontSize: 14,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      AutoSizeText(
                        "검색결과 ${widget.length}개",
                        maxLines: 1,
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      )
                    ],
                  ),
  }
}
