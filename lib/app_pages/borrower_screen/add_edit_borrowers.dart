import 'package:finance_gp/app_config/index.dart';
import 'package:finance_gp/app_utils/alert_service.dart';
import 'package:finance_gp/app_utils/app_bar.dart';
import 'package:finance_gp/app_utils/app_button_widget.dart';
import 'package:finance_gp/app_utils/text_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEditBorrowers extends StatefulWidget {
  const AddEditBorrowers({super.key});

  @override
  State<AddEditBorrowers> createState() => _AddEditBorrowersState();
}

class _AddEditBorrowersState extends State<AddEditBorrowers> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _interestController = TextEditingController();
  final _outstandingController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mobileController = TextEditingController();
  final AlertService _alertService = AlertService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Add", action: []),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16.0),
              TextFormWidget(
                title: "Borrower Name",
                required: true,
                controller: _nameController,
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Borrower Name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormWidget(
                title: "Mobile Number",
                required: true,
                prefixIcon: Icons.phone_iphone_outlined,
                controller: _mobileController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Mobile Number';
                  }
                  if (value.toString().length != 10) {
                    return "Please enter valid mobile number.";
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),
              TextFormWidget(
                title: "Borrowed Amount",
                required: true,
                prefixIcon: Icons.attach_money_outlined,
                controller: _amountController,
                maxLength: 8,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Borrowed Amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormWidget(
                title: "Interest (%)",
                required: false,
                prefixIcon: Icons.percent,
                controller: _interestController,
                maxLength: 2,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextFormWidget(
                title: "Outstanding Amount",
                required: true,
                prefixIcon: Icons.account_balance_outlined,
                controller: _outstandingController,
                maxLength: 8,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Outstanding Amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormWidget(
                title: "Description",
                required: false,
                prefixIcon: Icons.description_outlined,
                controller: _descriptionController,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 28),
              AppButton(
                title: "Save",
                onPressed: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    _alertService.showLoading('Saving...');
                    try {
                      final supabase = Supabase.instance.client;
                      final response = await supabase
                          .from('borrow_master')
                          .insert({
                            'user_id': supabase.auth.currentUser!.id,
                            'name': _nameController.text.toString().trim(),
                            'amount': _amountController.text.toString(),
                            'interest':
                                _interestController.text.toString() == ""
                                ? 0
                                : _interestController.text,
                            'outstanding': _outstandingController.text
                                .toString(),
                            'description': _descriptionController.text
                                .toString()
                                .trim(),
                            'mobile': _mobileController.text.toString().trim(),
                          });
                      if (!context.mounted) return;
                      _alertService.successToast(
                        "Borrower saved successfully.",
                      );
                      Navigator.pushReplacementNamed(context, "my_borrowers");
                      printContent("Response ==> $response");
                    } catch (e) {
                      printContent("Error: ${e.toString()}");
                    } finally {
                      _alertService.hideLoading();
                      printDirect("===> Function Executed Completed <===");
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormWidget(
      title: label,
      required: false,
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
