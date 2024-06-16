import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/features/authentication/controllers/signup/sign_up_controller.dart';
import 'package:tesis3/features/authentication/screens/SignUp/verify_email.dart';
import 'package:tesis3/utils/validators/validation.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_string.dart';
import '../../../../../utils/helpers/helper_function.dart';
import 'TermOfCondition.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    super.key});


  @override
  Widget build(BuildContext context) {
    final dark=HelperFunctions.isDarkMode(context);
    final controller=Get.put(SignUpController());
    return Form(
      key: controller.signupFormKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.firstName,
                    validator: (value)=>Validator.validateEmptyText('Nombres', value),
                    expands:false,
                    decoration: const InputDecoration(
                        labelText: Texts.primerNombre,
                        prefixIcon: Icon(Iconsax.user)
                    ),
                  ),
                ),
                const SizedBox(width: Sizes.spaceBtwInputFields),
                Expanded(
                  child: TextFormField(
                    controller: controller.lastName,
                    validator: (value)=>Validator.validateEmptyText('Apellidos', value),
                    expands:false,
                    decoration: const InputDecoration(
                        labelText: Texts.apellido,
                        prefixIcon: Icon(Iconsax.user)
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            ///Username
            TextFormField(
              controller: controller.username,
              validator: (value)=>Validator.validateEmptyText('Nombre de Usuario', value),
              expands:false,
              decoration: const InputDecoration(
                  labelText: Texts.username,
                  prefixIcon: Icon(Iconsax.user_edit)
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            ///Email
            TextFormField(
              validator: (value)=>Validator.validateEmail(value),
              controller: controller.email,
              decoration: const InputDecoration(
                  labelText: Texts.email,
                  prefixIcon: Icon(Iconsax.direct)
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            ///Celular
            TextFormField(
              validator: (value)=>Validator.validatePhoneNumber(value),
              controller: controller.phoneNumber,
              decoration: const InputDecoration(
                  labelText: Texts.phoneNo,
                  prefixIcon: Icon(Iconsax.call)
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            ///Contraseña
            Obx(
              ()=> TextFormField(
                validator: (value)=>Validator.validatePassword(value),
                controller: controller.password,
                obscureText:controller.hidePassword.value,
                decoration: InputDecoration(
                  labelText: Texts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash : Iconsax.eye),
                  ),
                ),
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwInputFields),
            ///Términos y Condiciones
            const TermsAndConditionCheckbox(),
            const SizedBox(height: Sizes.spaceBtwSection),
            ///SignUp Button
            SizedBox(width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.signup(),
                child: const Text(Texts.createAccount)
              )
            )
          ],
        ));
  }
}

