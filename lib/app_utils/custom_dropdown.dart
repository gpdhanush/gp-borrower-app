import 'package:finance_gp/app_themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends FormField<dynamic> {
  CustomDropdown({
    super.key,
    required String title,
    required bool required,
    required List<DropdownMenuEntry<dynamic>> dropdownMenuEntries,
    dynamic initialSelection,
    ValueChanged<dynamic>? onSelected,
    super.validator,
    bool? search,
  }) : super(
         initialValue: initialSelection,
         builder: (state) {
           final theme = Theme.of(state.context);

           return Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               /// Label with required asterisk
               RichText(
                 text: TextSpan(
                   text: title,
                   style: const TextStyle(
                     color: AppColors.black,
                     fontSize: 14,
                     fontWeight: FontWeight.w500,
                   ),
                   children: required
                       ? [
                           const TextSpan(
                             text: ' *',
                             style: TextStyle(
                               color: Colors.redAccent,
                               fontSize: 14,
                               fontWeight: FontWeight.w500,
                             ),
                           ),
                         ]
                       : [],
                 ),
               ),
               const SizedBox(height: 5),

               /// Dropdown Menu
               SizedBox(
                 height: 45,
                 child: LayoutBuilder(
                   builder: (context, constraints) {
                     return DropdownMenu(
                       width: constraints.maxWidth,
                       expandedInsets: EdgeInsets.zero,
                       menuHeight:
                           MediaQuery.of(state.context).size.width / 1.5,
                       dropdownMenuEntries: dropdownMenuEntries,
                       initialSelection: initialSelection,
                       hintText: initialSelection == null ? title : null,
                       onSelected: (val) {
                         state.didChange(val); // update form state
                         state.validate(); // clear error once valid
                         if (onSelected != null) onSelected(val);
                       },

                       /// Search options
                       enableFilter: search ?? false,
                       enableSearch: search ?? false,
                       requestFocusOnTap: search ?? false,

                       /// Selected text style
                       textStyle: theme.textTheme.bodyMedium?.copyWith(
                         fontSize: 14,
                         fontWeight: FontWeight.w600,
                         overflow: TextOverflow.ellipsis,
                         fontFamily: 'Roboto',
                       ),

                       /// Fix alignment with proper padding
                       inputDecorationTheme: InputDecorationTheme(
                         contentPadding: const EdgeInsets.symmetric(
                           horizontal: 12,
                           vertical: 12,
                         ),
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5),
                           borderSide: const BorderSide(
                             color: Color(0xffD2D2D2),
                           ),
                         ),
                         enabledBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5),
                           borderSide: const BorderSide(
                             color: Color(0xffD2D2D2),
                           ),
                         ),
                         focusedBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5),
                           borderSide: const BorderSide(
                             color: AppColors.primary,
                           ),
                         ),
                         errorBorder: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5),
                           borderSide: const BorderSide(
                             color: Colors.redAccent,
                           ),
                         ),
                       ),

                       /// Dropdown list styling
                       menuStyle: MenuStyle(
                         padding: WidgetStateProperty.all(
                           const EdgeInsets.symmetric(horizontal: 12),
                         ),
                         backgroundColor: WidgetStateProperty.all(Colors.white),
                         elevation: WidgetStateProperty.all(8),
                       ),
                     );
                   },
                 ),
               ),

               /// Validation error message
               if (state.hasError)
                 Padding(
                   padding: const EdgeInsets.only(top: 5, left: 0),
                   child: Text(
                     state.errorText ?? '',
                     style: const TextStyle(
                       color: Colors.redAccent,
                       fontSize: 12,
                     ),
                   ),
                 ),
             ],
           );
         },
       );
}
