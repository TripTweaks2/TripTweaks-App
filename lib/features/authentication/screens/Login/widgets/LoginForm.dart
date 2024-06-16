import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/features/authentication/controllers/login/login_controller.dart';
import 'package:tesis3/features/authentication/screens/SignUp/signUp.dart';
import 'package:tesis3/features/authentication/screens/passwordConfiguration/reset_password.dart';
import 'package:tesis3/utils/validators/validation.dart';

import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_string.dart';
import '../../passwordConfiguration/forget_password.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(LogInController());
    return Form(
      key: controller.loginFormKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Sizes.spaceBtwSection,),
          child: Column(
            children: [
              ///Email
              TextFormField(
                controller: controller.email,
                validator: (value) => Validator.validateEmail(value),
                decoration: const InputDecoration(
                    prefixIcon:Icon(Iconsax.direct_right),
                    labelText: Texts.email
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwInputFields),
              ///Password
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
              const SizedBox(height: Sizes.spaceBtwInputFields / 2),
              ///Remember Me & Forget Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///Remember me
                  Row(
                    children: [
                      Obx(()=> Checkbox(value: controller.rememberMe.value,
                          onChanged: (value)=>controller.rememberMe.value = !controller.rememberMe.value)),
                      const Text(Texts.rememberMe),
                    ],
                  ),
                  ///Forget Password
                  TextButton(onPressed: ()=>Get.to(()=>const ForgetPassword()), child: const Text(Texts.forgetPassword))
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwSection),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () =>controller.emailAndPasswordSignIn(), child: const Text(Texts.Login))),
              const SizedBox(height: Sizes.spaceBtwItems),
              SizedBox(width: double.infinity, child: OutlinedButton(onPressed: ()=>Get.to(()=>const SignUp()), child: const Text(Texts.createAccount))),
              const SizedBox(height: Sizes.spaceBtwSection),
            ],
          ),
        ));
  }
}
