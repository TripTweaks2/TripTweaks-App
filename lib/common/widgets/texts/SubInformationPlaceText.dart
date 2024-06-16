import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubInformationPlaceText extends StatelessWidget {
  const SubInformationPlaceText({
    super.key,
    required this.text,
    this.maxLines=1,
    this.isLarge=false,
    this.lineThrough=false,
  });

  final String text;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ?Theme.of(context).textTheme.headlineMedium!.apply(decoration: lineThrough ? TextDecoration.lineThrough : null)
          :Theme.of(context).textTheme.titleLarge!.apply(decoration: lineThrough ? TextDecoration.lineThrough : null)
    );
  }
}