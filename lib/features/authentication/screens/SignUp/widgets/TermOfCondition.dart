import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_string.dart';
import '../../../../../utils/helpers/helper_function.dart';
import '../../../controllers/signup/sign_up_controller.dart';

class TermsAndConditionCheckbox extends StatelessWidget {
  const TermsAndConditionCheckbox({
    super.key
  });


  @override
  Widget build(BuildContext context) {
    final controller=SignUpController.instance;
    final dark=HelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(()=>Checkbox(value: controller.privacyPolicy.value,
              onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value)),
        ),
        const SizedBox(width: Sizes.spaceBtwItems),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${Texts.iAgreeTo} ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: '${Texts.privacyPolicy}',
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ? AppColors.white : AppColors.primaryElement,
                        decoration: TextDecoration.underline,
                        decorationColor: dark ? AppColors.white : AppColors.primaryElement,
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${Texts.and} ',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: '${Texts.termsofUse} ',
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: dark ? AppColors.white : AppColors.primaryElement,
                        decoration: TextDecoration.underline,
                        decorationColor: dark ? AppColors.white : AppColors.primaryElement,
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
