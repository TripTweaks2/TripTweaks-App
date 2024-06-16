import 'package:flutter/cupertino.dart';

import '../../../utils/constants/sizes.dart';
import 'ShimmerEffect.dart';

class BoxesShimmer extends StatelessWidget {
  const BoxesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: ShimmerEffect(width: 150, height: 110)),
            SizedBox(width: Sizes.spaceBtwItems),
            Expanded(child: ShimmerEffect(width: 150, height: 110)),
            SizedBox(width: Sizes.spaceBtwItems),
            Expanded(child: ShimmerEffect(width: 150, height: 110)),
            SizedBox(width: Sizes.spaceBtwItems),
          ],
        )
      ],
    );
  }
}
