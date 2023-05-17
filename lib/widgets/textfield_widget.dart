import 'package:flutter/material.dart';

import 'text_widget.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final String? hint;
  final bool? isObscure;
  final TextEditingController controller;
  final double? width;
  final double? height;
  final int? maxLine;
  final TextInputType? inputType;
  final Color? labelColor;

  const TextFieldWidget(
      {super.key,
      required this.label,
      this.hint = '',
      required this.controller,
      this.isObscure = false,
      this.width = 300,
      this.height = 45,
      this.maxLine = 1,
      this.inputType = TextInputType.text,
      this.labelColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextRegular(text: label, fontSize: 14, color: labelColor!),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: height,
          width: width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          child: TextFormField(
            keyboardType: inputType,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(color: Colors.white)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                  borderSide: const BorderSide(color: Colors.grey)),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              border: InputBorder.none,
            ),
            maxLines: maxLine,
            obscureText: isObscure!,
            controller: controller,
          ),
        ),
      ],
    );
  }
}
