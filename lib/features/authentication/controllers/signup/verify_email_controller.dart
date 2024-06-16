import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/SuccesScreen/SuccesScreen.dart';
import 'package:tesis3/common/widgets/loaders/loaders.dart';
import 'package:tesis3/data/repositories/authentication/authentication_repository.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/text_string.dart';

class VerifyEmailController extends GetxController{
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit(){
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  sendEmailVerification() async{
    try{
      await AuthenticationRepository.instance.sendEmailVerification();
      Loaders.successSnackBar(title: 'Correo enviado',message: 'Por favor revisa tu bandeja de entrada y verifica tu correo');
    } catch (e){
      Loaders.errorSnackBar(title: 'Oh vaya!', message: e.toString());
    }
  }

  setTimerForAutoRedirect(){
    Timer.periodic(const Duration(seconds: 1), (timer) async{
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if(user?.emailVerified ?? false){
        timer.cancel();
        Get.off(
            ()=>SuccessScreen(
                image: Images.checkRegister,
                title: Texts.yourAccountCreatedTitle,
                subtitle: Texts.yourAccountCreatedSubtitle,
                onPressed: () => AuthenticationRepository.instance.screenRedirect()),
        );
      }
    });
  }

  ///Manually check if email verified
  checkEmailVerificationStatus() async{
    final currentUser = FirebaseAuth.instance.currentUser;
    if( currentUser != null && currentUser.emailVerified){
      Get.off(
            ()=>SuccessScreen(
            image: Images.checkRegister,
            title: Texts.yourAccountCreatedTitle,
            subtitle: Texts.yourAccountCreatedSubtitle,
            onPressed: () => AuthenticationRepository.instance.screenRedirect()),
      );
    }
  }

}