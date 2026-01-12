import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class CustomTextFieldyear extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;
  final VoidCallback? onTap;

  const CustomTextFieldyear({
    Key? key,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}

class CustomTextFieldC extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const CustomTextFieldC({
    Key? key,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.characters,
      keyboardType: keyboardType,
      inputFormatters: [
        UpperCaseTextFormatter(),
      ],
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
    );
  }
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
class CustomDropdownVehile<T> extends StatelessWidget {
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) displayText;
  final ValueChanged<T?> onChanged;

  const CustomDropdownVehile({
    super.key,
    required this.hint,
    required this.items,
    required this.displayText,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      hint: Text(hint),
      isExpanded: true,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(displayText(item)),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    Key? key,
    required this.hint,
    required this.items,
    this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 11,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      isExpanded: true,
      value: value,
      hint: Text(hint),
      items: items
          .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      dropdownStyleData: DropdownStyleData(
        elevation: 4,
        maxHeight: 250,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        offset: const Offset(0, -5), // ✅ Adjust dropdown position
      ),
    );
  }
}

// class CustomDropdown extends StatelessWidget {
//   final String hint;
//   final List<String> items;
//   final String? value;
//   final ValueChanged<String?> onChanged;
//
//   const CustomDropdown({
//     Key? key,
//     required this.hint,
//     required this.items,
//     this.value,
//     required this.onChanged,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 12,
//           vertical: 14,
//         ),
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       ),
//       value: value,
//       hint: Text(hint),
//       items: items
//           .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
//           .toList(),
//       onChanged: onChanged,
//     );
//   }
// }

class CustomDatePicker extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final DateTime firstDate;
  final DateTime lastDate;

  const CustomDatePicker({
    Key? key,
    required this.label,
    required this.controller,
    required this.firstDate,
    required this.lastDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        // labelText: label,
        labelStyle: TextStyle(fontSize: 14, color: Colors.black54),
        hintText: label,
        suffixIcon: const Icon(Icons.calendar_month_outlined, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (picked != null) {
          controller.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        }
      },
    );
  }
}
