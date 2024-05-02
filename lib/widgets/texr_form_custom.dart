// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
// import 'package:todoapp/cubit/cubit.dart';

// ignore: must_be_immutable
class CustomFormFiled extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String label;
  final Widget? prefixIcon;
  void Function()? onTap;
  String? Function(String?)? validator;

  final bool readOnly;
  CustomFormFiled({
    super.key,
    this.controller,
    // required
    this.hintText,
    required this.label,
    required this.validator,
    this.prefixIcon,
    this.onTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    // var cubit = ToDoCubit.get(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        validator: validator,
        controller: controller,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: onTap,
        readOnly: readOnly,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          hintText: hintText,
          label: Text(label),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
