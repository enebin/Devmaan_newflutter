import 'util.dart';
import 'model/notice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:responsive_grid/responsive_grid.dart';

void main() {
  runApp(const MyApp());
}

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
  List<Notice> _notices = [
    Notice(
      company: Company(name: "Naver"),
      title: "귀여운 뉴비 모바일 개발자 모집",
      date: "2021-2022",
      link: "www.naver.com",
      year: Year(year: 0),
    )
  ];

  @override
  void initState() {
    super.initState();
    Util util = Util();
    setState(() {
      _isWeb = util.checkIsWeb();
      fetchData();
    });
  }

  void fetchData() {
    final databaseReference = FirebaseDatabase.instance.reference();

    databaseReference.child('notices').once().then((DataSnapshot snapshot) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value);

      setState(() {
        _notices = List<Notice>.from(
            data.values.map((notice) => Notice.fromJson(notice)));
      });
      print("[System] ${_notices.length} notices fetched.");
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = size.height / 2;
    final double itemWidth = size.width / 2;

    return Material(
        child: PageView(
      scrollDirection: Axis.vertical,
      children: [
        Scaffold(
          // appBar: AppBar(
          //   title: Text(widget.title),
          // ),
          body: ListView(
            children: [
              Banner(),
              CompanyList(),
              Align(
                alignment: Alignment.center,
                child: GridView(notices: _notices),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

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

class NoticeItem extends StatefulWidget {
  const NoticeItem({
    Key? key,
    required this.notice,
  }) : super(key: key);

  final Notice notice;

  @override
  State<NoticeItem> createState() => _NoticeItemState();
}

class _NoticeItemState extends State<NoticeItem> {
  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          height: 230,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  spreadRadius: 3,
                  color: Colors.grey.withOpacity(0.4),
                )
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Center(
                child: Column(
                  children: [
                    Text(widget.notice.title),
                    SizedBox(height: 15),
                    Image.asset(
                      'assets/' +
                          widget.notice.company.getName().toLowerCase() +
                          '.png',
                      width: 70,
                      fit: BoxFit.fitWidth,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        print("SSS");
      },
      onHover: (isHovering) {
        if (isHovering) {
          setState(() {
            scale = 1.2;
          });
        } else {
          setState(() {
            scale = 1.0;
          });
        }
      },
    );
  }
}

class CompanyList extends StatelessWidget {
  final List<String> _iconAssets = [
    'assets/coupang.png',
    'assets/kakao.png',
    'assets/line.png',
    'assets/naver.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 3))
        ],
      ),
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _iconAssets.length,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (BuildContext context, int index) {
          return Row(
            children: [
              Image.asset(
                _iconAssets[index],
                width: 80,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(width: 20)
            ],
          );
        },
      ),
    );
  }
}

class Banner extends StatelessWidget {
  const Banner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(fit: StackFit.loose, children: [
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/background.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Top 7 채용 공고는\n 여기 다 모여있음!",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
