import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/effects/Category_Shimmer.dart';
import 'package:tesis3/common/widgets/layout/grid_layout.dart';
import 'package:tesis3/common/widgets/texts/SectionHeadings.dart';
import 'package:tesis3/features/travel/controllers/tour/SearchController.dart';
import 'package:tesis3/features/travel/controllers/type_controller.dart';
import 'package:tesis3/features/travel/screens/allTours/all_tours.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/sizes.dart';

import '../../../../../common/widgets/app_bar/appBar.dart';
import '../../../../../common/widgets/effects/SearchCategoryShimmer.dart';
import '../../../../../common/widgets/image_text_widget/VerticalImageText.dart';
import '../../../../../common/widgets/images/CircularImage.dart';
import '../../../../../common/widgets/touristPlace/Card/PlaceTouristCardVertical.dart';
import '../../../../../utils/helpers/helper_function.dart';
import '../../../controllers/category_controller.dart';
import '../../../models/category_model.dart';
import '../../typesTours/TypesTours.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);

  final categoryController = CategoryController.instance;
  final searchController = Get.put(TSearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text('Buscando', style: Theme.of(context).textTheme.headlineMedium),
        actions: [TextButton(onPressed: () => Get.back(), child: const Text('Cancelar'))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Search bar & Filter Button
              Row(
                children: [
                  /// Search
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      onChanged: (query) => searchController.searchProducts(query, sortingOption: searchController.selectedSortingOption.value),
                      decoration: const InputDecoration(prefixIcon: Icon(Iconsax.search_normal), hintText: 'Buscando'),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceBtwItems),

                  /// Filter
                  OutlinedButton(
                    onPressed: () => filterModalBottomSheet(context),
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey)),
                    child: const Icon(Iconsax.setting, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwSection),

              /// Search
              Obx(
                    () => searchController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    :
                // Show search if not Empty
                searchController.searchResults.isNotEmpty
                    ? GridLayout(
                  itemCount: searchController.searchResults.length,
                  itemBuilder: (_, index) => PlaceTouristCardVertical(tour: searchController.searchResults[index]),
                )
                    : brandsAndCategories(context),
              ),

              const SizedBox(height: Sizes.spaceBtwSection),
            ],
          ),
        ),
      ),
    );
  }

  /// Brands & Categories Widget
  Column brandsAndCategories(BuildContext context) {
    final brandController = Get.put(TypeController());
    final categoryController = Get.put(CategoryController());
    final isDark = HelperFunctions.isDarkMode(context);
    return Column(
      children: [
        /// Brands Heading
        const SectionHeading(title: 'Tipos de Lugares Turísticos', showActionButton: false),

        /// -- Brands
        Obx(
              () {
            // Check if categories are still loading
            if (brandController.isLoading.value) return const CategoryShimmer();

            /// Data Found
            return Wrap(
              children: brandController.allTypes
                  .map((brand) => GestureDetector(
                onTap: () => Get.to(TypesTours(typeModel: brand)),
                child: Padding(
                  padding: const EdgeInsets.only(top: Sizes.md),
                  child: VerticalImageText(
                    image: brand.image,
                    title: brand.name,
                    isNetworkImage: true,
                    textColor: HelperFunctions.isDarkMode(context) ? AppColors.white : AppColors.dark,
                    backgroundColor: HelperFunctions.isDarkMode(context) ? AppColors.darkerGrey : AppColors.light,
                  ),
                ),
              ))
                  .toList(),
            );
          },
        ),
        const SizedBox(height: Sizes.spaceBtwSection),

        /// Categories
        const SectionHeading(title: 'Categorías', showActionButton: false),
        const SizedBox(height: Sizes.spaceBtwItems),

        /// Obx widget for reactive UI updates based on the state of [categoryController].
        /// It displays a shimmer loader while categories are being loaded, shows a message if no data is found,
        /// and renders a horizontal list of featured categories with images and text.
        Obx(
              () {
            // Check if categories are still loading
            if (categoryController.isLoading.value) return const SearchCategoryShimmer();

            // Check if there are no featured categories found
            if (categoryController.allCategories.isEmpty) {
              return Center(child: Text('No Data Found!', style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
            } else {
              /// Data Found
              // Display a horizontal list of featured categories with images and text
              final categories = categoryController.allCategories;
              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: Sizes.spaceBtwItems),
                itemCount: categories.length,
                shrinkWrap: true,
                itemBuilder: (_, index) => GestureDetector(
                  onTap: () => Get.to(
                        () => AllTours(
                      title: categories[index].name,
                      futureMethod: categoryController.getCategoryTour(categoryId: categories[index].id),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircularImage(
                        width: 25,
                        height: 25,
                        padding: 0,
                        isNetworkImage: true,
                        overlayColor: isDark ? AppColors.white : AppColors.dark,
                        image: categories[index].image,
                      ),
                      const SizedBox(width: Sizes.spaceBtwItems / 2),
                      Text( truncateText(categories[index].name, 5), overflow: TextOverflow.ellipsis, maxLines: 1)
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Future<dynamic> filterModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: Sizes.defaultSpace,
          right: Sizes.defaultSpace,
          top: Sizes.defaultSpace,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SectionHeading(title: 'Filtro', showActionButton: false),
                  IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.close_square))
                ],
              ),
              const SizedBox(height: Sizes.spaceBtwSection / 2),

              /// Sort
              Text('Sort by', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Sizes.spaceBtwItems / 2),

              _buildSortingDropdown(),
              const SizedBox(height: Sizes.spaceBtwSection),

              /// Categories

              Text('Category', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: Sizes.spaceBtwItems),
              _buildCategoryList(),
              const SizedBox(height: Sizes.spaceBtwSection),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    searchController.search();
                    Get.back();
                  },
                  child: const Text('Apply'),
                ),
              ),
              const SizedBox(height: Sizes.spaceBtwSection),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortingDropdown() {
    return Obx(
          () => DropdownButton<String>(
        value: searchController.selectedSortingOption.value,
        onChanged: (String? newValue) {
          if (newValue != null) {
            searchController.selectedSortingOption.value = newValue;
            searchController.search(); // Trigger the search when the sorting option changes
          }
        },
        items: searchController.sortingOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categoryController.allCategories.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildCategoryTile(categoryController.allCategories[index]);
      },
    );
  }

  Widget _buildCategoryTile(CategoryModel category) {
    return category.parentId.isEmpty ? Obx(() => _buildParentCategoryTile(category)) : const SizedBox.shrink();
  }

  Widget _buildParentCategoryTile(CategoryModel category) {
    return ExpansionTile(
      title: Text(category.name),
      children: _buildSubCategories(category.id),
    );
  }

  List<Widget> _buildSubCategories(String parentId) {
    List<CategoryModel> subCategories = categoryController.allCategories.where((cat) => cat.parentId == parentId).toList();
    return subCategories.map((subCategory) => _buildSubCategoryTile(subCategory)).toList();
  }

  Widget _buildSubCategoryTile(CategoryModel category) {
    return RadioListTile(
      title: Text(category.name),
      value: category.id,
      groupValue: searchController.selectedCategoryId.value,
      onChanged: (value) {
        searchController.selectedCategoryId.value = value.toString();
      },
    );
  }

  String truncateText(String text, int wordLimit) {
    List<String> words = text.split(' ');
    if (words.length > wordLimit) {
      return words.take(wordLimit).join(' ') + '...';
    }
    return text;
  }
}