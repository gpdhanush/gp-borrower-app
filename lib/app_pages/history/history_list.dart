import 'package:finance_gp/app_config/index.dart';
import 'package:finance_gp/app_utils/index.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'history_model.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final AlertService _alertService = AlertService();
  List<HistoryMaster> historyLists = [];

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
      // final response = await supabase
      //     .from('history_master')
      //     .select()
      //     .eq('user_id', supabase.auth.currentUser!.id)
      //     .order('created_at', ascending: false);
      final response = await supabase
          .from('history_full')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);

      print(response);
      setState(() {
        historyLists = (response as List)
            .map((e) => HistoryMaster.fromJson(e))
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
          title: "History of Payments",
          action: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, "add_edit_history"),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        body: historyLists.isEmpty
            ? const AppNoDataFound(showSecond: true)
            : ListView.builder(
                itemCount: historyLists.length,
                itemBuilder: (context, index) {
                  final borrower = historyLists[index];
                  return ListTile(
                    leading: const Icon(Icons.person_2_outlined),
                    title: Text(
                      "Name: ${borrower.borrowName.toString()} \nType: ${borrower.typeName} \nStatus: ${borrower.statusName}",
                    ),
                    subtitle: Text(
                      "Amount: ${borrower.amount.toString()}\nNotes: ${borrower.notes.toString()}\nDate: ${borrower.paymentDate.toString()}",
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert_outlined,
                        color: Colors.black,
                      ),
                      onSelected: (value) async {
                        switch (value) {
                          case 'Edit':
                            // TODO: Add edit logic
                            break;
                          case 'Delete':
                            final confirm = await _alertService.confirmAlert(
                              context,
                              "Are you sure you want to delete this borrower?",
                            );
                            if (confirm == true) {
                              // await deleteList(borrower.id);
                            }
                            break;
                          case 'View':
                            // TODO: Add view logic
                            break;
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'View', child: Text('View')),
                        PopupMenuItem(value: 'Edit', child: Text('Edit')),
                        PopupMenuItem(value: 'Delete', child: Text('Delete')),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
