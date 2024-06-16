import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/utils/constants/colors.dart';

class SettingMenuTile extends StatelessWidget {
  const SettingMenuTile({super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing});

  final IconData icon;
  final String title,subtitle;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,size: 28,color: AppColors.primaryElement),
      title: Text(title,style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle,style: Theme.of(context).textTheme.labelMedium),
      trailing: trailing
    );
  }
}
