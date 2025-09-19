import 'package:finance_gp/app_config/app_logs.dart';
import 'package:finance_gp/app_utils/index.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'borrower_model.dart';

class BorrowerList extends StatefulWidget {
  const BorrowerList({super.key});

  @override
  State<BorrowerList> createState() => _BorrowerListState();
}

class _BorrowerListState extends State<BorrowerList> {
  final AlertService _alertService = AlertService();
  List<Borrower> borrowerLists = [];

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
          .from('borrow_master')
          .select()
          .eq('user_id', supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);

      setState(() {
        borrowerLists = (response as List)
            .map((e) => Borrower.fromJson(e))
            .toList();
      });
    } catch (e, st) {
      _alertService.errorToast(e.toString());
      printContent("ERROR: $e\n$st");
    } finally {
      _alertService.hideLoading();
    }
  }

  /// Delete Borrower
  Future<void> deleteList(int borrowerId) async {
    final supabase = Supabase.instance.client;
    printContent("Delete ID: $borrowerId");
    try {
      final response = await supabase
          .from('borrow_master')
          .delete()
          .eq('id', borrowerId)
          .select();

      printContent("Delete Response: $response");
      await getList(); // refresh after deletion
    } on PostgrestException catch (e) {
      printContent("POSTGREST ERROR: ${e.message}");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Database error: ${e.message}')));
    } catch (e, st) {
      printContent("GENERIC ERROR: $e\n$st");
      _alertService.errorToast(e.toString());
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
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.indigoAccent,
          centerTitle: true,
          title: const Text(
            "My Borrowers",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "add_edit_borrower"),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        body: borrowerLists.isEmpty
            ? const AppNoDataFound(showSecond: true)
            : ListView.builder(
                itemCount: borrowerLists.length,
                itemBuilder: (context, index) {
                  final borrower = borrowerLists[index];
                  return ListTile(
                    leading: const Icon(Icons.person_2_outlined),
                    title: Text(
                      "${borrower.name.toUpperCase().trim()} (ROI: ${borrower.interest})",
                    ),
                    subtitle: Text("Out: ${borrower.outstanding}"),
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
                              await deleteList(borrower.id);
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
