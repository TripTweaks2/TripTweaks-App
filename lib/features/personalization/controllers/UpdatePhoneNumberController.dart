import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tesis3/features/personalization/controllers/user_controller.dart';

import '../../../common/widgets/loaders/loaders.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/constants/images_string.dart';
import '../../../utils/helpers/network_manager.dart';
import '../../../utils/popups/fullScreenLoader.dart';
import '../screens/Profile/ProfileScreen.dart';

class UpdatePhoneNumberController extends GetxController {
  static UpdatePhoneNumberController get instance => Get.find();

  final phoneNumber = TextEditingController();
  final userController = UserController.instance;
  final userRepository = Get.find<UserRepository>();
  GlobalKey<FormState> updatePhoneNumberFormKey = GlobalKey<FormState>();

  Future<void> updatePhoneNumber() async {
    try {
      FullScreenLoader.openLoadingDialog('Actualizando número de teléfono...', Images.loading);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      if (!updatePhoneNumberFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Actualizar el número de teléfono en el repositorio
      await userRepository.updateSingleField({'PhoneNumber': phoneNumber.text});

      // Actualizar el valor localmente
      userController.user.value.phoneNumber = phoneNumber.text;

      FullScreenLoader.stopLoading();
      Loaders.successSnackBar(title: '¡Éxito!', message: 'Número de teléfono actualizado correctamente');

      Get.off(() => const ProfileScreen());
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }
}