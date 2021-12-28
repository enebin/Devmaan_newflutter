import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'model/notice.dart';

class Util {
  static double mobileScreenSize = 450;
  static double mediumScreenSize = 800;

  bool checkIsWeb() {
    bool isWeb;
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        isWeb = false;
      } else {
        isWeb = true;
      }
    } catch (e) {
      isWeb = true;
    }

    return isWeb;
  }

  void fetchData(List<Notice> _notices) {
    final databaseReference = FirebaseDatabase.instance.reference();

    databaseReference.child('notices').once().then((DataSnapshot snapshot) {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value);

      _notices = List<Notice>.from(
          data.values.map((notice) => Notice.fromJson(notice)));
      print("[System] ${_notices.length} notices fetched.");
    });
  }
}
