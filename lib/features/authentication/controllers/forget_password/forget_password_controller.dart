import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/loaders/loaders.dart';
import 'package:tesis3/data/repositories/authentication/authentication_repository.dart';
import 'package:tesis3/features/authentication/screens/passwordConfiguration/reset_password.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/helpers/network_manager.dart';
import 'package:tesis3/utils/popups/fullScreenLoader.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance =>Get.find();

  final email=TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  sendPasswordResetEmail() async{
    try{
      FullScreenLoader.openLoadingDialog('Estamos procesando tu solicitud ...', Images.loading);
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){FullScreenLoader.stopLoading();return;}

      if(!forgetPasswordFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();return;
      }

      await AuthenticationRepository.instance.sendPasswordResendEmail(email.text.trim());
      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(title: 'Correo electrónico enviado', message: 'Enlace de correo electrónico enviado para reestablecer contraseña');
      Get.to(()=>ResetPassword(email: email.text.trim()));
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh vaya!',message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async{
    try{
      FullScreenLoader.openLoadingDialog('Estamos procesando tu solicitud ...', Images.loading);
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){FullScreenLoader.stopLoading();return;}

      if(!forgetPasswordFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();return;
      }

      await AuthenticationRepository.instance.sendPasswordResendEmail(email);
      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(title: 'Correo electrónico enviado', message: 'Enlace de correo electrónico enviado para reestablecer contraseña'.tr);
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh vaya!',message: e.toString());
    }
  }
}