import 'package:finance_gp/app_config/app_logs.dart';
import 'package:finance_gp/app_pages/borrower_screen/borrower_model.dart';
import 'package:finance_gp/app_pages/dropdown_master/dropdown_model.dart';
import 'package:finance_gp/app_utils/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEditHistory extends StatefulWidget {
  const AddEditHistory({super.key});

  @override
  State<AddEditHistory> createState() => _AddEditHistoryState();
}

class _AddEditHistoryState extends State<AddEditHistory> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _paymentDateController = TextEditingController();

  DateTime? _selectedPaymentDate;
  List<DropdownMaster> paymentTypeList = [];
  List<DropdownMaster> paymentStatusList = [];
  List<Borrower> borrowerLists = [];

  final AlertService _alertService = AlertService();

  /// INIT STATE
  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _paymentDateController.dispose();
    super.dispose();
  }

  /// Fetch both dropdowns & borrowers in parallel
  Future<void> _fetchInitialData() async {
    _alertService.showLoading("Fetching...");
    try {
      await Future.wait([getDropDownLists(), getBorrowersList()]);
    } catch (e, st) {
      _alertService.errorToast(e.toString());
      printContent("ERROR: $e\n$st");
    } finally {
      _alertService.hideLoading();
    }
  }

  /// Get dropdown lists (Payment Type + Payment Status)
  Future<void> getDropDownLists() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    final results = await Future.wait([
      supabase
          .from('dropdown_master')
          .select()
          .eq('key', 'payment_type')
          .eq('user_id', userId),
      supabase
          .from('dropdown_master')
          .select()
          .eq('key', 'payment_status')
          .eq('user_id', userId),
    ]);

    setState(() {
      paymentTypeList = (results[0] as List)
          .map((e) => DropdownMaster.fromJson(e))
          .toList();
      paymentStatusList = (results[1] as List)
          .map((e) => DropdownMaster.fromJson(e))
          .toList();
    });
  }

  /// Get borrower list
  Future<void> getBorrowersList() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    final response = await supabase
        .from('borrow_master')
        .select()
        .eq('user_id', userId);

    setState(() {
      borrowerLists = (response as List)
          .map((e) => Borrower.fromJson(e))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Add Payment", action: const []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /// Borrower Dropdown
              CustomDropdown(
                title: 'Select Borrower',
                required: true,
                dropdownMenuEntries: borrowerLists
                    .map((e) => DropdownMenuEntry(value: e.id, label: e.name))
                    .toList(),
                validator: (value) =>
                    value == null ? "Borrower is mandatory!" : null,
                onSelected: (value) {
                  FocusScope.of(context).unfocus();
                  printContent("Selected Borrower ID: $value");
                },
              ),
              const SizedBox(height: 16.0),

              /// Amount + Payment Date
              Row(
                children: [
                  Expanded(
                    child: TextFormWidget(
                      title: "Amount",
                      required: true,
                      // prefixIcon: Icons.currency_rupee_outlined,
                      controller: _amountController,
                      maxLength: 8,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Amount is mandatory!'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextFormWidget(
                      title: "Date",
                      required: true,
                      focusNode: AlwaysDisabledFocusNode(),
                      // prefixIcon: Icons.calendar_today_outlined,
                      controller: _paymentDateController,
                      onTap: () => _selectDate(context),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Date is mandatory!'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              /// Payment Type
              CustomDropdown(
                title: 'Payment Type',
                required: true,
                dropdownMenuEntries: paymentTypeList
                    .map((e) => DropdownMenuEntry(value: e.id, label: e.name))
                    .toList(),
                validator: (value) =>
                    value == null ? "Type is mandatory!" : null,
                onSelected: (value) {
                  FocusScope.of(context).unfocus();
                  printContent("Selected Payment Type ID: $value");
                },
              ),
              const SizedBox(height: 16.0),

              /// Payment Status
              CustomDropdown(
                title: 'Payment Status',
                required: true,
                dropdownMenuEntries: paymentStatusList
                    .map((e) => DropdownMenuEntry(value: e.id, label: e.name))
                    .toList(),
                validator: (value) =>
                    value == null ? "Status is mandatory!" : null,
                onSelected: (value) {
                  FocusScope.of(context).unfocus();
                  printContent("Selected Payment Status ID: $value");
                },
              ),
              const SizedBox(height: 16.0),

              /// Notes
              TextFormWidget(
                title: "Notes",
                required: false,
                maxLines: 3,
                controller: _notesController,
              ),
              const SizedBox(height: 25.0),

              /// Submit Button
              AppButton(
                title: "Add Payment",
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    printContent("Form valid ✅");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      barrierColor: Colors.black54,
      locale: const Locale("en", "US"),
      initialDate: _selectedPaymentDate ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 50),
      lastDate: DateTime(DateTime.now().year + 50),
    );
    if (picked != null && picked != _selectedPaymentDate) {
      setState(() {
        _selectedPaymentDate = picked;
        _paymentDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
}
