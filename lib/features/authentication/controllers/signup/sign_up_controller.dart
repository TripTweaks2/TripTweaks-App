import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/loaders/loaders.dart';
import 'package:tesis3/data/repositories/authentication/authentication_repository.dart';
import 'package:tesis3/data/repositories/user/user_repository.dart';
import 'package:tesis3/features/authentication/screens/SignUp/verify_email.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/helpers/network_manager.dart';
import 'package:tesis3/utils/popups/fullScreenLoader.dart';

import '../../../personalization/models/user_model.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  ///Variables
  final hidePassword=true.obs;
  final privacyPolicy=true.obs;
  final email=TextEditingController();
  final lastName=TextEditingController();
  final username=TextEditingController();
  final password=TextEditingController();
  final firstName=TextEditingController();
  final phoneNumber=TextEditingController();
  GlobalKey<FormState> signupFormKey=GlobalKey<FormState>();


  ///SignUp
  /*Future<void> signup() async{
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog('Estamos procesando tu información...', Images.loading);

      //Check Internet Conectividad
      final isConnected=await NetworkManager.instance.isConnected();
      if(!isConnected)return;

      //Validacion del Form
      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }


      //Validacion Check Politicas
      if(!privacyPolicy.value){
        Loaders.warningSnackBar(
            title: 'Aceptar Política de Privacidad',
            message: 'Para crear una cuenta, debes de leer y aceptar nuestros términos y condiciones'
        );
        return;
      }

      //Registro de Usuario en Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      //Save user data in Firebase FireStore
      final newUser = UserModel(
        id:userCredential.user!.uid,
        firstName:firstName.text.trim(),
        lastName:lastName.text.trim(),
        username:username.text.trim(),
        email:email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture:''
      );

      final userRepository=Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);

      // Stop Loading
      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(title: 'Felicitaciones', message: 'Tu cuenta ha sido creada! Verifica tu correo a continuación');

      await Future.delayed(const Duration(seconds: 1));


      // Redirigir a VerifyEmail
      Get.to(() => VerifyEmail(email: email.text.trim()));

    } catch (e){
      //Mostar algún error de usuario
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh vaya!',message: e.toString());

    } finally {
      FullScreenLoader.stopLoading();
    }
  }*/



  /// -- SIGNUP
  Future<void> signup() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog('Estamos procesando tu información...', Images.loading);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        FullScreenLoader.stopLoading();
        Loaders.warningSnackBar(
            title: 'Aceptar Política de Privacidad',
            message: 'Para crear una cuenta, debes de leer y aceptar nuestros términos y condiciones'
        );
        return;
      }

      // Register user in the Firebase Authentication & Save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance.registerWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Save Authenticated user data in the Firebase Firestore
      final newUser = UserModel(
        id:userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        profilePicture: '',
      );

      final userRepository=Get.put(UserRepository());
      userRepository.saveUserRecord(newUser);


      // Remove Loader
      FullScreenLoader.stopLoading();

      // Show Success Message
      Loaders.successSnackBar(title: 'Congratulations', message: 'Your account has been created! Verify email to continue.');

      // Move to Verify Email Screen
      Get.to(() => VerifyEmail(email: email.text.trim()));
    } catch (e) {
      // Show some Generic Error to the user
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh vaya!',message: e.toString());
    }
  }
}