import 'package:flutter/material.dart';

class TitledBar extends AppBar{
  final String titleText;

  TitledBar(this.titleText): super(title: Text(titleText));
}