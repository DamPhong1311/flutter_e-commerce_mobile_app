import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductInformation extends StatelessWidget {
  final String productName;
  final double averageRating;
  final int totalReviews;
  final int discountedPrice;
  final int originalPrice;
  final int discountPercentage;
  final List<Color> colors;
  final int selectedColorIndex;
  final Function(int) onColorSelected;
  final Map<String, String> specifications;

  const ProductInformation({
    Key? key,
    required this.productName,
    required this.averageRating,
    required this.totalReviews,
    required this.discountedPrice,
    required this.originalPrice,
    required this.discountPercentage,
    required this.colors,
    required this.selectedColorIndex,
    required this.onColorSelected,
    required this.specifications,
  }) : super(key: key);

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
            productName,
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
                "$averageRating",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(width: 5),
              Text(
                "($totalReviews đánh giá)",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Text(
                formatCurrency(discountedPrice),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: KColors.primaryColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Text(
                formatCurrency(originalPrice),
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "-$discountPercentage%",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text("Màu sắc", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Row(
            children: List.generate(
              colors.length,
              (index) => GestureDetector(
                onTap: () => onColorSelected(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors[index],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: selectedColorIndex == index
                          ? Colors.black
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text("Thông số kỹ thuật",
              style: Theme.of(context).textTheme.titleLarge),
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
          }).toList(),
        ],
      ),
    );
  }
}
