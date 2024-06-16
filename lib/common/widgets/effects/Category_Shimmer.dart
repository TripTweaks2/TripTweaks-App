import 'package:flutter/cupertino.dart';
import 'package:tesis3/common/widgets/effects/ShimmerEffect.dart';
import 'package:tesis3/utils/constants/sizes.dart';

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key,this.itemCount=6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: itemCount,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_,__) => const SizedBox(width: Sizes.spaceBtwItems),
        itemBuilder: (_,index){
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerEffect(width: 55, height: 55,radius: 55),
                SizedBox(height: Sizes.spaceBtwItems/2),
                ShimmerEffect(width: 55, height: 0)
              ],
            );
        },
      )
    );
  }
}
