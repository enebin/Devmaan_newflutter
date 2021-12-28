import 'dart:math';
import 'dart:async';

import 'package:devmaan_newflutter/widget/search_result.dart';

import 'util.dart';
import './model/notice.dart';
import './widget/banner.dart' as banner;
import './widget/company_list.dart';
import './widget/grid_view.dart' as grid;
import 'widget/search_textfield_row.dart';
import './widget/sort_button.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

// TODO: 검색 사라지는 문제
// TODO: 회사 로고 크기다듬기
// TODO: 공고 최신순

void main() {
  runApp(const MyApp());
}

enum SortBy { date, year }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '네카라쿠배-NKLCB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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

  Map<String, bool> isSortSelected = {
    'year': false,
    'date': false,
    'random': true,
  };

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

  void searchResultHandler() {
    setState(() {
      _loadCount = 0;
    });
  }

  void sortByYear() {
    String keyWord = 'year';

    setState(() {
      print("Sort by $keyWord");
      for (String s in isSortSelected.keys) {
        if (s != keyWord) {
          isSortSelected[s] = false;
        } else {
          isSortSelected[keyWord] = true;
        }
      }

      _notices
          .sort((a, b) => a.year.getRawYear().compareTo(b.year.getRawYear()));
    });
  }

  void sortByDate() {
    String keyWord = 'date';

    setState(() {
      print("Sort by $keyWord");
      for (String s in isSortSelected.keys) {
        if (s != keyWord) {
          isSortSelected[s] = false;
        } else {
          isSortSelected[keyWord] = true;
        }
      }

      _notices.sort((a, b) => a.parsedDate[1].compareTo(b.parsedDate[1]));
    });
  }

  void sortByRandom() {
    String keyWord = 'random';

    setState(() {
      print("Sort by $keyWord");
      for (String s in isSortSelected.keys) {
        if (s != keyWord) {
          isSortSelected[s] = false;
        } else {
          isSortSelected[keyWord] = true;
        }
      }

      _notices.shuffle();
    });
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

  // void startTimer() {
  //   const oneSec = const Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isMobile = Util.mobileScreenSize > size.width;

    Widget FloatingButton = FloatingActionButton(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      onPressed: () {
        scrollController.animateTo(0,
            duration: Duration(milliseconds: 750), curve: Curves.ease);
        Future.delayed(const Duration(milliseconds: 750), () {
          setState(() {
            _loadCount = 0;
          });
        });
      },
      child: Icon(Icons.arrow_upward),
    );

    Widget ProgressView = Container(
      padding: EdgeInsets.all(120),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.blue),
      ),
    );

    return Material(
        child: PageView(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollDirection: Axis.vertical,
      children: [
        GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              floatingActionButton: FloatingButton,
              backgroundColor: Colors.grey.withOpacity(0.1),
              body: Container(
                child: ListView(
                  controller: scrollController,
                  children: [
                    // 상단 배너
                    banner.Banner(),

                    // 회사 리스트
                    CompanyList(
                      onTap: updateCompanyFilter,
                      filters: companyFilter,
                    ),

                    // 검색창
                    SearchTextField(
                      onSubmit: updateSearchFilter,
                      onDismiss: searchResultHandler,
                      submittedText: searchFilter,
                      length: _filteredNotices.length,
                    ),
                    SizedBox(height: 15),

                    // 정렬 버튼들
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SortButton(
                          onTap: sortByYear,
                          color: Colors.blue.withOpacity(
                              isSortSelected['year'] == true ? 1 : 0),
                          text: "🏢 경력순",
                        ),
                        SizedBox(width: 15),
                        SortButton(
                          onTap: sortByDate,
                          color: Colors.blue.withOpacity(
                              isSortSelected['date'] == true ? 1 : 0),
                          text: "📅 마감일순",
                        ),
                        SizedBox(width: 15),
                        SortButton(
                          onTap: sortByRandom,
                          color: Colors.blue.withOpacity(
                              isSortSelected['random'] == true ? 1 : 0),
                          text: "😊 랜덤 ~",
                        ),
                      ],
                    ),

                    // 컨텐츠 그리드 뷰
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
            ))
      ],
    ));
  }
}
