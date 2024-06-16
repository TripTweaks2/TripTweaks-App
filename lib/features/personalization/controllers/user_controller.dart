import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesis3/common/widgets/loaders/loaders.dart';
import 'package:tesis3/data/repositories/authentication/authentication_repository.dart';
import 'package:tesis3/data/repositories/user/user_repository.dart';
import 'package:tesis3/features/authentication/screens/Login/LogIn.dart';
import 'package:tesis3/features/personalization/models/user_model.dart';
import 'package:tesis3/features/personalization/screens/Profile/widgets/re_authenticate_user_login_form.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/helpers/network_manager.dart';
import 'package:tesis3/utils/popups/fullScreenLoader.dart';

import '../../../utils/constants/sizes.dart';

class UserController extends GetxController{
  static UserController get instance => Get.find();

  final profileLoading =false.obs;
  Rx<UserModel> user=UserModel.empty().obs;

  final hidePassword=false.obs;
  final imageUploading=false.obs;
  final verifyEmail=TextEditingController();
  final verifyPassword=TextEditingController();
  final userRepository=Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey=GlobalKey<FormState>();

  @override
  void onInit(){
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async{
    try{
      profileLoading.value=true;
      final user=await userRepository.fetchUserDetails();
      this.user(user);
      profileLoading.value=false;

    } catch(e){
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }


  Future<void> saveUserRecord(UserCredential? userCredentials) async{
    try{
      await fetchUserRecord();

      if(user.value.id.isEmpty){
        if(userCredentials!=null){
          final nameParts=UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final userName=UserModel.generateUsername(userCredentials.user!.displayName ?? '');

          final user=UserModel(
              id: userCredentials.user!.uid,
              firstName: nameParts[0], lastName: nameParts.length>1?nameParts.sublist(1).join(' '):'',
              username: userName,
              email: userCredentials.user!.email ?? '', phoneNumber: userCredentials.user!.phoneNumber ?? '', profilePicture: userCredentials.user!.photoURL?? '');
          await userRepository.saveUserRecord(user);

        }
      }

    }catch(e){
      Loaders.warningSnackBar(
          title: 'Data no guardada',
          message: 'Algo salió mal mientras guardabamos tu información. Intenta guarda nuevamente tu información'
      );
    }
  }

  void deleteAccountWarningPopup(){
    Get.defaultDialog(
      contentPadding: EdgeInsets.all(Sizes.md),
      title: 'Eliminar cuenta',
      middleText:'¿Estás seguro que deseas eliminar tu cuenta permanentemente? Esta acción no es reversible y toda tu información se borrará permanentemente.',
      confirm: ElevatedButton(onPressed: () async =>deleteUserAccount(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent,side: const BorderSide(color: Colors.redAccent)),
          child: const Padding(padding: EdgeInsets.symmetric(horizontal: Sizes.lg),child: Text('Eliminar'),)),
      cancel: OutlinedButton(onPressed: () => Navigator.of(Get.overlayContext!).pop(), child: const Text('Cancelar'))
    );
  }

  void deleteUserAccount() async{
    try{
      FullScreenLoader.openLoadingDialog('Procesando', Images.loading);

      final auth=AuthenticationRepository.instance;
      final provider=auth.authUser!.providerData.map((e)=>e.providerId).first;
      if(provider.isNotEmpty){
        if(provider == "google.com"){
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          FullScreenLoader.stopLoading();
          Get.offAll(()=>const LoginScreen());
        }  else if (provider == 'facebook.com') {
          await auth.signInWithFacebook();
          await auth.deleteAccount();
          FullScreenLoader.stopLoading();
          Get.offAll(() => const LoginScreen());
        } else if(provider=="password"){
          FullScreenLoader.stopLoading();
          Get.to(()=>const ReAuthLoginForm());
        }
      }
    } catch (e){
      FullScreenLoader.stopLoading();
      Loaders.warningSnackBar(title: 'Oh vaya!', message: e.toString());
    }
  }

  Future<void> reAuthenticateEmailAndPasswordUser() async{
    try{
      FullScreenLoader.openLoadingDialog('Procesando', Images.loading);
      final isConnected=await NetworkManager.instance.isConnected();
      if(!isConnected){
        FullScreenLoader.stopLoading();
        return;
      }

      if(!reAuthFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      FullScreenLoader.stopLoading();
      Get.offAll(()=>const LoginScreen());
    } catch (e){
      FullScreenLoader.stopLoading();
      Loaders.warningSnackBar(title: 'Oh vaya!', message: e.toString());
    }
  }

  uploadUserProfilePicture() async{
    try{
      final image=await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70,maxHeight: 512,maxWidth: 512);
      if(image!=null){
        imageUploading.value=true;
        final imageUrl=await userRepository.uploadImage('Users/Images/', image);
        Map<String,dynamic> json={'ProfilePicture':imageUrl};
        await userRepository.updateSingleField(json);


        user.value.profilePicture=imageUrl;
        user.refresh();
        Loaders.successSnackBar(title: 'Felicitaciones!',message: 'Tu Foto de perfil ha sido actualizada');
      }
    }catch(e){
      Loaders.warningSnackBar(title: 'Oh vaya!', message: 'Algo salió mal : $e');
    } finally{
      imageUploading.value=false;
    }
  }

}