import 'package:flutter/material.dart';
import '../model/notice.dart';
import './company_item.dart';

class CompanyList extends StatefulWidget {
  void Function(Company) onTap;
  CompanyList({Key? key, required this.onTap}) : super(key: key);

  @override
  State<CompanyList> createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  final List<Company> companies = [
    Company(name: 'naver'),
    Company(name: 'kakao'),
    Company(name: 'line'),
    Company(name: 'coupang')
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
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: companies.length,
          padding: EdgeInsets.symmetric(horizontal: 10),
          itemBuilder: (BuildContext context, int index) {
            return CompanyItem(company: companies[index], widget: widget);
          },
        ),
      ),
    );
  }
}