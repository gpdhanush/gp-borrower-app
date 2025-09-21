import 'package:finance_gp/app_config/index.dart';
import 'package:finance_gp/app_themes/app_colors.dart';
import 'package:finance_gp/app_utils/index.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dropdown_model.dart';

class DropdownList extends StatefulWidget {
  const DropdownList({super.key});

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  final AlertService _alertService = AlertService();
  List<DropdownMaster> dropdownLists = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  /// Fetch Borrower List
  Future<void> getList() async {
    _alertService.showLoading("Fetching...");
    try {
      final supabase = Supabase.instance.client;
      final response = await supabase
          .from('dropdown_master')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);
      setState(() {
        dropdownLists = response
            .map((e) => DropdownMaster.fromJson(e))
            .toList();
      });
    } catch (e, st) {
      _alertService.errorToast(e.toString());
      printContent("ERROR: $e\n$st");
    } finally {
      _alertService.hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, "home");
        }
      },
      child: Scaffold(
        appBar: AppBarWidget(
          title: "Dropdown Master",
          action: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "add_edit_dropdowns");
              },
              icon: Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        body: dropdownLists.isEmpty
            ? AppNoDataFound(showSecond: true)
            : ListView.builder(
                itemCount: dropdownLists.length,
                itemBuilder: (context, index) {
                  final list = dropdownLists[index];
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 23,
                      backgroundColor: AppColors.primary,
                      child: Icon(
                        Icons.list_alt_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                    title: Text(list.name.toUpperCase()),
                    subtitle: Text(list.key.toUpperCase()),
                    trailing: Icon(Icons.more_vert_outlined),
                  );
                },
              ),
      ),
    );
  }
}
