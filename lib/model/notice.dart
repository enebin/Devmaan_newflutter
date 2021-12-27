import 'package:flutter/material.dart';

class Notice {
  final Company company;
  final String title;
  final String date;
  final List<DateTime> parsedDate;
  final String link;
  final Year year;
  bool like;

  Notice({
    required this.company,
    required this.title,
    required this.date,
    required this.parsedDate,
    required this.link,
    required this.year,
    this.like = false,
  });

  factory Notice.fromJson(Map<Object?, Object?> json) {
    return Notice(
      company: Company(name: json['company'] as String),
      title: json['title'] as String,
      date: json['date'] as String,
      parsedDate: (json['parsed_date'] as List<dynamic>).map((date) {
        try {
          if (date == '0') {
            return DateTime(9999, 12, 31);
          } else {
            return DateTime.parse(date);
          }
        } catch (e) {
          print(e);
          print(date);
          assert(1 != 1);
          return DateTime(9999, 12, 31);
        }
      }).toList(),
      link: json['link'] as String,
      year: Year(year: json['year'] as int),
    );
  }
}

class Year {
  final int year;
  Year({required this.year});

  int getRawYear() {
    return year;
  }

  Color getColor() {
    switch (year) {
      case 0:
        return const Color.fromRGBO(246, 226, 78, 1);
      case -1:
        return const Color.fromRGBO(246, 200, 78, 1);
      default:
        return Color.fromRGBO(
            246, 180, 78, year > 5 ? 1 : 0.2 * (year.toDouble()));
    }
  }

  String getStrYear() {
    switch (year) {
      case 0:
        return "경력 미기재";
      case -1:
        return "경력 무관";
      default:
        return "$year년";
    }
  }
}

class Company {
  final String name;
  Company({required this.name});

  String getName() {
    return this.name;
  }

  Color getColor() {
    switch (this.name) {
      case 'Naver':
        return const Color.fromRGBO(36, 221, 92, 1);
      case 'Kakao':
        return const Color.fromRGBO(254, 223, 9, 1);
      case 'Line':
        return const Color.fromRGBO(127, 234, 127, 1);
      case 'Coupang':
        return const Color.fromRGBO(215, 50, 39, 0.8);
      case 'Baemin':
        return const Color.fromRGBO(215, 50, 39, 0.8);
      default:
        return Colors.red;
    }
  }

  static List<String> values = ['Naver', 'Line', 'Kakao', 'Coupang', 'Baemin'];
}
