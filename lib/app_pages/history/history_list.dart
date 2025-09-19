import 'package:finance_gp/app_utils/index.dart';
import 'package:flutter/material.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "History",
        action: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "add_edit_history");
            },
            icon: Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: AppNoDataFound(showSecond: true),
    );
  }
}
