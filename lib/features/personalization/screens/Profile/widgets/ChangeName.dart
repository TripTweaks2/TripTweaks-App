import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/constants/text_string.dart';
import 'package:tesis3/utils/validators/validation.dart';

import '../../../controllers/UpdateNameController.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(UpdateNameController());
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Cambiar Nombre',style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usa tu real nombre para una fácil verificación. Este nombre aparecerá en varias páginas',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: Sizes.spaceBtwSection),
            Form(
              key: controller.updateUserNameFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.firstName,
                    validator: (value)=>Validator.validateEmptyText('Nombre', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: Texts.primerNombre,prefixIcon: Icon(Iconsax.user)),
                  ),
                  const SizedBox(height: Sizes.spaceBtwInputFields),
                  TextFormField(
                    controller: controller.lastName,
                    validator: (value)=>Validator.validateEmptyText('Apellidos', value),
                    expands: false,
                    decoration: const InputDecoration(labelText: Texts.apellido,prefixIcon: Icon(Iconsax.user)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceBtwSection),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: ()=>controller.updateUserName(),child: const Text('Guardar'),),
            )
          ],
        ),
      ),
    );
  }
}
