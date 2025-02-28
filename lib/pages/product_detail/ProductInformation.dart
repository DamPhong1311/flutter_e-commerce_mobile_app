import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductInformation extends StatelessWidget {
  final String name;
  final String rateProduct;
  final String totalReviews;
  final String priceProduct;
  final String oldPrice;
  final String salePercent;
  final bool isSale;
  final Map<String, String> specifications;

  const ProductInformation({
    super.key,
    required this.name,
    required this.rateProduct,
    required this.totalReviews,
    required this.priceProduct,
    required this.oldPrice,
    required this.salePercent,
    required this.specifications,
    required this.isSale,
  });

  String formatCurrency(int price) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 24),
              const SizedBox(width: 5),
              Text(
                rateProduct,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 5),
              Text(
                totalReviews,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                priceProduct,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: KColors.primaryColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              isSale
                  ? Row(
                      children: [
                        Text(
                          oldPrice,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                  ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            salePercent,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  : SizedBox()
            ],
          ),
          const SizedBox(height: 20),
          Text("Specifications", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          ...specifications.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key,
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(entry.value,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
