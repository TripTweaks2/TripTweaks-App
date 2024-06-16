import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/utils/constants/sizes.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key, required this.onPressed, required this.title, required this.value,  this.showIcon = true,
  });


  final bool showIcon;
  final VoidCallback? onPressed;
  final String title,value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBtwItems /1.5),
        child: Row(
          children: [
            Expanded(flex:5,child: Text(title,style: Theme.of(context).textTheme.bodySmall,overflow: TextOverflow.ellipsis)),
            Expanded(flex:5,child: Text(value,style: Theme.of(context).textTheme.bodyMedium,overflow: TextOverflow.ellipsis)),
            if (showIcon) const Expanded(child: Icon(Iconsax.arrow_right_34, size: 18)), // Mostrar el icono solo si showIcon es true
          ],
        ),
      ),
    );
  }
}
