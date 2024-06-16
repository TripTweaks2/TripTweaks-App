import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/loaders/loaders.dart';
import 'package:tesis3/data/repositories/user/user_repository.dart';
import 'package:tesis3/features/personalization/controllers/user_controller.dart';
import 'package:tesis3/features/personalization/screens/Profile/ProfileScreen.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/helpers/network_manager.dart';
import 'package:tesis3/utils/popups/fullScreenLoader.dart';

class UpdateNameController extends GetxController{
    static UpdateNameController get instance=>Get.find();

    final firstName=TextEditingController();
    final lastName=TextEditingController();
    final userController=UserController.instance;
    final userRepository=Get.put(UserRepository());
    GlobalKey<FormState> updateUserNameFormKey=GlobalKey<FormState>();

    @override
    void onInit(){
    initializeNames();
    super.onInit();
  }

  Future<void> initializeNames() async{
    firstName.text=userController.user.value.firstName;
    lastName.text=userController.user.value.lastName;
  }

  Future<void> updateUserName() async{
    try
    {
      FullScreenLoader.openLoadingDialog('Estamos actualizando su información...', Images.loading);

      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        FullScreenLoader.stopLoading();
        return;
      }

      if(!updateUserNameFormKey.currentState!.validate()){
        FullScreenLoader.stopLoading();
        return;
      }

      Map<String,dynamic> name = {'FirstName':firstName.text.trim(),'LastName':lastName.text.trim()};
      await userRepository.updateSingleField(name);

      userController.user.value.firstName = firstName.text.trim();
      userController.user.value.lastName = lastName.text.trim();

      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(title: 'Felicitaciones',message: 'Tu Nombre ha sido actualizado');

      Get.off(() => const ProfileScreen());


    } catch (e){
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oh vaya!', message: e.toString());
    }

  }

}