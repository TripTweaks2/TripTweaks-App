import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/common/widgets/effects/vertical_tour_shimmer.dart';
import 'package:tesis3/features/travel/screens/allTours/widgets/SortableTours.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/cloud_helper_function.dart';

import '../../controllers/tour/AllToursController.dart';
import '../../models/tour_model.dart';

class AllTours extends StatelessWidget {
  const AllTours({super.key, required this.title, this.query, required this.futureMethod});

  final String title;
  final Query? query;
  final Future<List<TourModel>>? futureMethod;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllToursController());
    return Scaffold(
      appBar: TAppBar(title: Text(title),showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: FutureBuilder(future: futureMethod ?? controller.fetchToursByQuery(query),
            builder: (context, snapshot) {
              const loader=VerticalTourShimmer();
              final widget= CloudHelperFunction.checkMultiRecordState(snapshot: snapshot,loader: loader);
              if(widget!=null) return widget;
              final tours = snapshot.data!;
              return SortableTours(tours: tours);
        }
      ),
    )));
  }
}
