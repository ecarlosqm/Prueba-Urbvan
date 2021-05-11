import 'package:flutter/material.dart';

typedef void OptionSected<T>(T optionValue);

class FloatingOptionWidget<T> extends StatelessWidget {
  final T value;
  final String title;
  final OptionSected<T> onSelect;
  final bool selected;

  const FloatingOptionWidget({
    Key? key,
    required this.value,
    required this.title,
    required this.onSelect,
    required this.selected,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () => onSelect(value),
      trailing: selected ? Icon(Icons.check_circle_sharp) : null,
    );
  }
}
