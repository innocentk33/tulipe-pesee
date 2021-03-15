import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final TextInputType inputType;
  final Widget suffix;
  final bool enabled;
  final TextAlign textAlign;

  const InputText(
      {Key key, this.hint, this.controller, this.inputType, this.suffix, this.enabled = true, this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        textAlign: textAlign ?? TextAlign.left,
        enabled: enabled,
        controller: controller,
        decoration: InputDecoration(
            hintText: hint, border: InputBorder.none, suffix: suffix),
        keyboardType: inputType ?? TextInputType.text,
      ),
    );
  }
}
