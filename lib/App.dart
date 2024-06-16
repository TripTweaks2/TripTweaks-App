import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesis3/bindings/general_bindings.dart';
import 'package:tesis3/features/authentication/screens/OnBoarding/OnBoarding.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(backgroundColor: AppColors.primaryElement, body: Center(child: CircularProgressIndicator(color: Colors.white,),),),
    );
  }
}
