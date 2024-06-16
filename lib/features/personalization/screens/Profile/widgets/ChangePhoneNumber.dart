import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/app_bar/appBar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/UpdatePhoneNumberController.dart';

class ChangePhoneNumber extends StatelessWidget {
  const ChangePhoneNumber({Key? key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatePhoneNumberController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Cambiar Número de Teléfono', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Introduce tu nuevo número de teléfono',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwSection),
            Form(
              key: controller.updatePhoneNumberFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.phoneNumber,
                    validator: (value) => Validator.validatePhoneNumber(value),
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: 'Número de Teléfono', prefixIcon: Icon(Iconsax.call)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSection),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updatePhoneNumber(),
                child: const Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}