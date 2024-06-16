import 'package:flutter/cupertino.dart';
import 'package:tesis3/common/widgets/effects/ShimmerEffect.dart';
import 'package:tesis3/utils/constants/sizes.dart';

class ListTileShimmer extends StatelessWidget {
  const ListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            ShimmerEffect(width: 50, height: 50,radius: 50),
            SizedBox(width: Sizes.spaceBtwItems),
            Column(
              children: [
                ShimmerEffect(width: 100, height: 15),
                SizedBox(height: Sizes.spaceBtwItems/2),
                ShimmerEffect(width: 80, height: 12),
              ],
            )
          ],
        )
      ],
    );
  }
}
