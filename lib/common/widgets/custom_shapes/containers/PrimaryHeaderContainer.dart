import 'package:flutter/cupertino.dart';

import '../../../../utils/constants/colors.dart';
import '../curved_edges/CurvedEdgeWidget.dart';
import 'CircularContainer.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedEdgeWidget(
      child:Container(
        color: AppColors.primaryElement,
        child: Stack(
          children: [
            Positioned(top: -150,right: -250,child: CircularContainer(background: AppColors.textWhite.withOpacity(0.1),)),
            Positioned(top: 100,right: -300,child: CircularContainer(background: AppColors.textWhite.withOpacity(0.1),)),
            child,
          ],
        ),
      )
    );
  }
}
