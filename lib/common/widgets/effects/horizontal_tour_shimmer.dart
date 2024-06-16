import 'package:flutter/cupertino.dart';

import '../../../utils/constants/sizes.dart';
import '../layout/grid_layout.dart';
import 'ShimmerEffect.dart';

class HorizontalTourShimmer extends StatelessWidget {
  const HorizontalTourShimmer({super.key,this.itemCount=4});

  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceBtwSection),
      height: 120,
      child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context,index) => const SizedBox(width: Sizes.spaceBtwItems),
          itemCount: itemCount,
          itemBuilder: (_,__) => const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerEffect(width: 120, height: 120),
              SizedBox(width: Sizes.spaceBtwItems),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: Sizes.spaceBtwItems / 2),
                  ShimmerEffect(width: 160, height: 15),
                  SizedBox(height: Sizes.spaceBtwItems / 2),
                  ShimmerEffect(width: 110, height: 15),
                  SizedBox(height: Sizes.spaceBtwItems / 2),
                  ShimmerEffect(width: 80, height: 15),
                  Spacer()
                ],
              )
            ],
          ),
      ),
    );
  }
}