import 'package:flutter/cupertino.dart';
import 'package:tesis3/common/widgets/effects/ShimmerEffect.dart';
import 'package:tesis3/common/widgets/layout/grid_layout.dart';
import 'package:tesis3/utils/constants/sizes.dart';

class VerticalTourShimmer extends StatelessWidget {
  const VerticalTourShimmer({super.key,this.itemCount=4});

  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return GridLayout(itemCount: itemCount, itemBuilder: (_,__)=> const SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerEffect(width: 180, height: 180),
          SizedBox(height: Sizes.spaceBtwItems),

          ShimmerEffect(width: 160, height: 15),
          SizedBox(height: Sizes.spaceBtwItems / 2),
          ShimmerEffect(width: 110, height: 15)
        ],
      ),
    ));
  }
}
