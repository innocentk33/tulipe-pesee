import 'package:flutter/material.dart';

class ListData<T> extends StatelessWidget {
  final List<T> items;
  final Function(T) data;
  final Function(T) onClick;
  final String emptyMessage;

  const ListData(
      {Key key, this.items, this.data, this.onClick, this.emptyMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return items == null || items.isEmpty
        ? Center(
            child: Text(
              emptyMessage,
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemCount: items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              var item = items[index];
              return GestureDetector(
                onTap: () => onClick(item),
                child: data(item),
              );
            },
          );
  }
}
