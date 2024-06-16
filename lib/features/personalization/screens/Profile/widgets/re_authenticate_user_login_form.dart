import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/features/personalization/controllers/user_controller.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/constants/text_string.dart';
import 'package:tesis3/utils/validators/validation.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller=UserController.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Re-Autenticación de Usuario')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.verifyEmail,
                  validator:Validator.validateEmail,
                  decoration: const InputDecoration(prefixIcon: Icon(Iconsax.direct_right),labelText: Texts.email),
                ),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                Obx(() => TextFormField(
                  obscureText: controller.hidePassword.value,
                  controller: controller.verifyPassword,
                  validator: (value) => Validator.validateEmptyText('Contraseña', value),
                  decoration: InputDecoration(
                    labelText: Texts.password,
                    prefixIcon: const Icon(Iconsax.password_check),
                    suffixIcon: IconButton(
                      onPressed: ()=>controller.hidePassword.value =!controller.hidePassword.value,
                      icon: const Icon(Iconsax.eye_slash),
                    )
                  ),
                )),
                const SizedBox(height: Sizes.spaceBtwInputFields),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(onPressed: ()=> controller.reAuthenticateEmailAndPasswordUser(),child: const Text('Verificar')),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
