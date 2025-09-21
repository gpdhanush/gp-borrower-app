import 'package:finance_gp/app_config/index.dart';
import 'package:finance_gp/app_utils/index.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddEditDropdown extends StatefulWidget {
  const AddEditDropdown({super.key});

  @override
  State<AddEditDropdown> createState() => _AddEditDropdownState();
}

class _AddEditDropdownState extends State<AddEditDropdown> {
  String? selectedOption; // For radio
  final TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AlertService _alertService = AlertService();

  Future<void> _saveForm() async {
    FocusScope.of(context).unfocus(); // Unfocus keyboard
    if (_formKey.currentState!.validate()) {
      if (selectedOption == null) {
        // Show error if radio not selected
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select Payment Type or Status")),
        );
        return;
      }
      _alertService.showLoading();
      try {
        final supabase = Supabase.instance.client;
        final response = await supabase.from('dropdown_master').insert({
          'user_id': supabase.auth.currentUser!.id,
          'name': nameController.text.toString().trim(),
          'key': selectedOption.toString(),
        });
        if (!mounted) return;
        _alertService.successToast("Saved successfully.");
        Navigator.pushReplacementNamed(context, "dropdowns");
        printContent("Response ==> $response");
      } catch (e) {
        printContent("Error: ${e.toString()}");
      } finally {
        _alertService.hideLoading();
        printDirect("===> Function Executed Completed <===");
      }
      // All validations passed, handle save logic here
      printContent("Selected Option: $selectedOption");
      printContent("Dropdown Name: ${nameController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "Add Dropdown", action: []),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// RADIO BUTTONS
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "Select Payment Option",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              RadioGroup<String>(
                groupValue: selectedOption,
                onChanged: (String? value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioMenuButton<String>(
                      value: "payment_type",
                      groupValue: selectedOption,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      child: Text("Payment Type"),
                    ),
                    RadioMenuButton<String>(
                      value: "payment_status",
                      groupValue: selectedOption,
                      onChanged: (String? value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      child: Text("Payment Status"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              /// NAME TEXT FIELD
              TextFormWidget(
                title: "Dropdown Name",
                controller: nameController,
                required: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter dropdown name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25.0),

              /// SAVE BUTTON
              AppButton(title: "Save", onPressed: _saveForm),
            ],
          ),
        ),
      ),
    );
  }
}
