import 'dart:math';

import 'util.dart';
import './model/notice.dart';
import './widget/banner.dart' as banner;
import './widget/company_list.dart';
import './widget/grid_view.dart' as grid;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

void main() {
  runApp(const MyApp());
}

enum SortBy { company, title, date, year }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isWeb = false;

  ScrollController scrollController = ScrollController();
  final _loadThisMuch = 21;
  int _loadCount = 1;

  TextEditingController textController = TextEditingController();

  List<Notice> _notices = [];
  String searchFilter = "";
  List<String> companyFilter = [];

  List<Notice> get _filteredNotices {
    final filtered = _notices
        .where((element) {
          if (companyFilter.isEmpty) {
            return true;
          } else {
            return companyFilter.contains(element.company.name.toLowerCase());
          }
        })
        .toList()
        .where((element) {
          bool isIn = true;
          if (searchFilter == "") {
            return true;
          } else {
            return element.title
                .toLowerCase()
                .contains(searchFilter.toLowerCase());
          }
        })
        .toList();

    return filtered.sublist(
        0, min(filtered.length, (_loadCount + 1) * _loadThisMuch));
  }

  @override
  void initState() {
    super.initState();
    Util util = Util();
    scrollController = ScrollController()..addListener(_scrollListener);

    setState(() {
      _isWeb = util.checkIsWeb();
      fetchData();
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  void fetchData({bool shuffle = true}) {
    final databaseReference = FirebaseDatabase.instance.reference();

    databaseReference.child('notices').once().then((DataSnapshot snapshot) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value);

      setState(() {
        _notices = List<Notice>.from(
            data.values.map((notice) => Notice.fromJson(notice)));
        if (shuffle) {
          _notices.shuffle();
        }
      });
      print("[System] ${_notices.length} notices fetched.");
    });
  }

  void updateCompanyFilter(Company company) {
    var loc = companyFilter.indexOf(company.name);
    if (loc != -1) {
      setState(() {
        companyFilter.removeAt(loc);
        _loadCount = 0;
      });
    } else {
      setState(() {
        companyFilter.add(company.name);
        _loadCount = 0;
      });
    }
  }

  void updateSearchFilter(String filter) {
    setState(() {
      searchFilter = filter;
    });
  }

  void sortByType(SortBy condition) {
    if (condition == SortBy.company) {
      setState(() {
        _notices
            .sort((a, b) => a.company.getName().compareTo(b.company.getName()));
      });
    } else if (condition == SortBy.title) {
      setState(() {
        _notices.sort((a, b) => a.title.compareTo(b.title));
      });
    } else if (condition == SortBy.year) {
      setState(() {
        _notices
            .sort((a, b) => a.year.getRawYear().compareTo(b.year.getRawYear()));
      });
    } else if (condition == SortBy.date) {}
  }

  void _scrollListener() {
    if (scrollController.position.extentAfter < 150 &&
        !(_loadCount > _notices.length / _loadThisMuch + 1)) {
      print(_loadCount);
      setState(() {
        _loadCount += 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = size.height / 2;
    final double itemWidth = size.width / 2;

    Widget ProgressView = Container(
      padding: EdgeInsets.all(120),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );

    return Material(
        child: PageView(
      scrollDirection: Axis.vertical,
      children: [
        Scaffold(
          backgroundColor: Colors.grey.withOpacity(0.1),
          body: Container(
            child: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              controller: scrollController,
              children: [
                banner.Banner(),
                CompanyList(onTap: updateCompanyFilter),
                SearchTextField(onSubmit: updateSearchFilter),
                if (_notices.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.center,
                    child: grid.GridView(notices: _filteredNotices),
                  ),
                ] else ...[
                  ProgressView,
                ],
              ],
            ),
          ),
        )
      ],
    ));
  }
}

class SearchTextField extends StatefulWidget {
  SearchTextField({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  void Function(String) onSubmit;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  bool _isFocused = false;
  String submitted = "";
  TextEditingController textController = TextEditingController();

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
          decoration: const InputDecoration(
            fillColor: Colors.white,
            hoverColor: Colors.grey,
            hintText: "채용 공고 검색",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
            border: InputBorder.none,
            icon: Padding(
                padding: EdgeInsets.only(left: 13),
                child: Icon(Icons.search, size: 15)),
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
              alignment: Alignment.centerRight,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("최신"),
                  ),
                  SearchBar,
                ],
              ),
            ),
          ),
          if (submitted != "") ...[
            Positioned(
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 100,
                  padding: EdgeInsets.only(right: 25),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.onSubmit("");
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
