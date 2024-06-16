import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/enums.dart';

class BrandTitleText extends StatelessWidget {
  const BrandTitleText({super.key, this.color, required this.title, this.maxLines=1, this.textAlign = TextAlign.center, this.textSizes = TextSizes.small});

  final Color? color;
  final String title;
  final int maxLines;
  final TextAlign? textAlign;
  final TextSizes textSizes;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: textSizes == TextSizes.small
        ? Theme.of(context).textTheme.labelMedium!.apply(color: color)
        : textSizes == TextSizes.medium
          ? Theme.of(context).textTheme.bodyLarge!.apply(color: color)
          : textSizes == TextSizes.large
            ? Theme.of(context).textTheme.titleLarge!.apply(color: color)
            : Theme.of(context).textTheme.bodyMedium!.apply(color: color)
    );
  }
}
