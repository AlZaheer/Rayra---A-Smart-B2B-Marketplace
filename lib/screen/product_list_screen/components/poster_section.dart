import 'package:client_app/utility/extensions.dart';
import 'package:get/get.dart';

import '../../../core/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utility/app_data.dart';
import '../../../utility/animation/open_container_wrapper.dart';
import '../../product_details_screen/product_detail_screen.dart';

class PosterSection extends StatelessWidget {
  const PosterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: dataProvider.posters.length,
            itemBuilder: (_, index) {
              // Use firstWhereOrNull to avoid the "Bad state: No element" error
              final product = context.dataProvider.allProducts.firstWhereOrNull(
                    (product) => product.sId == dataProvider.posters[index].productId,
              );

              // If no product is found, return an empty container or a placeholder
              if (product == null) {
                return Container(); // Or return a placeholder widget
              }

              return OpenContainerWrapper(
                nextScreen: ProductDetailScreen(product),
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Container(
                    width: 300,
                    decoration: BoxDecoration(
                      color: AppData.randomPosterBgColors[index],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${dataProvider.posters[index].posterName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(color: Colors.white),
                              ),
                              const SizedBox(height: 8),
                              OpenContainerWrapper(
                                nextScreen: ProductDetailScreen(product),
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ),
                                  child: const Text(
                                    "Get Now",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Image.network(
                          '${dataProvider.posters[index].imageUrl}',
                          height: 125,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            return const Icon(Icons.error, color: Colors.red);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}