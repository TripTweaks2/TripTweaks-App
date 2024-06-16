import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/utils/constants/colors.dart';

class OptionChoiceChip extends StatelessWidget {
  const OptionChoiceChip({super.key, required this.text, required this.selected, this.onSelected});

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;


  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
        label: Text(text),
        selected: selected,
        onSelected: onSelected,
        backgroundColor: AppColors.primaryElement, // Color de fondo deseado
        labelStyle: TextStyle(color: selected ? AppColors.black : null),
    );
  }
}
