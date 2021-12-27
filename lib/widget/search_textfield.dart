import 'package:flutter/material.dart';

class SearchTextField extends StatefulWidget {
  SearchTextField({
    Key? key,
    required this.onSubmit,
    required this.onDismiss,
  }) : super(key: key);

  void Function(String) onSubmit;
  VoidCallback onDismiss;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool _isFocused = false;
  String submitted = "";
  TextEditingController textController = TextEditingController();

  void _submitHandler(String text) {
    widget.onSubmit(text);
    setState(() {
      submitted = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    var SearchBar = Container(
      width: 300,
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
            widget.onSubmit(text);
            setState(() {
              submitted = text;
            });
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
          if (submitted != "") ...[
            Positioned(
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  width: 150,
                  padding: EdgeInsets.only(right: 25),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.onSubmit("");
                        widget.onDismiss;
                        textController.text = "";
                        submitted = "";
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.cancel, size: 12),
                        SizedBox(width: 5),
                        Text(submitted),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
