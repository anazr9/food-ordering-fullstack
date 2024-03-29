import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Function(String val)? onChanged;
  final double? height;
  final void Function(String)? onSubmitted;
  final TextInputAction? inputAction;
  final TextInputType? keyboardType;
  final bool? obscure;

  const CustomTextField(
      {super.key,
      this.hint,
      this.fontSize,
      this.fontWeight,
      this.onChanged,
      this.height = 54.0,
      this.onSubmitted,
      this.inputAction,
      this.keyboardType,
      this.obscure});

  final _border = const OutlineInputBorder(
    borderRadius: BorderRadius.zero,
    borderSide: BorderSide(
      color: Colors.black,
      width: 1.5,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.secondary,
            blurRadius: 0,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: TextField(
        obscureText: obscure ?? false,
        keyboardType: keyboardType ?? TextInputType.text,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        textInputAction: inputAction,
        cursorColor: Colors.black,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.black,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16.0),
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
          ),
          enabledBorder: _border,
          border: _border,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
