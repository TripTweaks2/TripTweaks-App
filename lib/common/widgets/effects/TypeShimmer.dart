import 'package:flutter/cupertino.dart';
import 'package:tesis3/common/widgets/effects/ShimmerEffect.dart';
import 'package:tesis3/common/widgets/layout/grid_layout.dart';

class TypeShimmer extends StatelessWidget {
  const TypeShimmer({super.key, this.itemCount = 4});

  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return GridLayout(mainAxisExtent:80,itemCount: itemCount, itemBuilder: (_,__)=>const ShimmerEffect(width: 300, height: 80));
  }
}
