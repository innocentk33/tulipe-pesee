import 'package:flutter/material.dart';

import 'button.dart';

class MenuButton extends Button {
  final String text;
  final Image prefix;
  final Function onPressed;

  MenuButton(this.text, {this.prefix, this.onPressed}) : super(text, prefix: prefix, color: Colors.white, textColor: Colors.black, onPressed: onPressed);

}
