import 'package:flutter/cupertino.dart';

class ApiResponse<T> {
  bool hasError;
  String body;
  String message;
  List<T> items;

  ApiResponse({this.items, this.hasError, this.body, this.message});

  Widget when({Widget error(String message), Widget data(List<T> items)}) {
    if (hasError) {
      return error(message);
    }

    if( items == null || items.isEmpty){
      return error("Aucun élément");
    }

    return data(items);
  }
}
