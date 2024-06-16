import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tesis3/common/widgets/loaders/loaders.dart';
import 'package:tesis3/data/repositories/authentication/authentication_repository.dart';
import 'package:tesis3/features/personalization/controllers/user_controller.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/helpers/network_manager.dart';
import 'package:tesis3/utils/popups/fullScreenLoader.dart';

class LogInController extends GetxController{
  final rememberMe=false.obs;
  final hidePassword=true.obs;
  final localStorage=GetStorage();
  final email=TextEditingController();
  final password=TextEditingController();
  GlobalKey<FormState> loginFormKey=GlobalKey<FormState>();
  final userController=Get.put(UserController());

  @override
  void onInit(){
    final rememberedEmail = localStorage.read('REMEMBER_ME_EMAIL');
    final rememberedPassword = localStorage.read('REMEMBER_ME_PASSWORD');

    if (rememberedEmail != null) {
      email.text = rememberedEmail;
    }

    if (rememberedPassword != null) {
      password.text = rememberedPassword;
    }
    super.onInit();
  }

  Future<void> emailAndPasswordSignIn() async{
    try{
      FullScreenLoader.openLoadingDialog('Iniciando sesión en ...', Images.loading);

      final isConnected=await NetworkManager.instance.isConnected();
      if(!isConnected){
        FullScreenLoader.stopLoading();
        return;
      }

      if(!loginFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        return;
      }

      if(rememberMe.value){
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      final userCredentials=await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      FullScreenLoader.stopLoading();

      AuthenticationRepository.instance.screenRedirect();
    } catch (e){
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh vaya!',message: e.toString());
    }
  }

  Future<void> googleSignIn() async{
    try {
      FullScreenLoader.openLoadingDialog('Iniciando sesión en ...', Images.login);

      final isConnected=await NetworkManager.instance.isConnected();
      if(!isConnected){
        FullScreenLoader.stopLoading();
        return;
      }

      final userCredentials=await AuthenticationRepository.instance.signInWithGoogle();
      await userController.saveUserRecord(userCredentials);
      FullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();
    } catch (e){
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh vaya!',message: e.toString());
    }

  }


  Future<void> facebookSignIn() async {
    try {
      FullScreenLoader.openLoadingDialog('Iniciando sesión en ...', Images.login);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      final userCredentials = await AuthenticationRepository.instance.signInWithFacebook();
      await userController.saveUserRecord(userCredentials);
      FullScreenLoader.stopLoading();
      AuthenticationRepository.instance.screenRedirect();

    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh vaya!', message: e.toString());
    }
  }
}

