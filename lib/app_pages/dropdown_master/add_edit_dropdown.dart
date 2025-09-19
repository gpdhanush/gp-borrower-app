import 'package:finance_gp/app_utils/index.dart';
import 'package:flutter/material.dart';

class AddEditDropdown extends StatefulWidget {
  const AddEditDropdown({super.key});

  @override
  State<AddEditDropdown> createState() => _AddEditDropdownState();
}

class _AddEditDropdownState extends State<AddEditDropdown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Add Dropdown", action: []),
      body: AppNoDataFound(showSecond: true),
    );
  }
}
