import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/app_bar/app_bar.dart';
import 'package:ecommerece_flutter_app/common/widgets/curved_edges/curved_edges_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductImages extends StatelessWidget {
  final List<String> imgList;
  final int currentIndex;
  final Function(int) onImageSelected;

  const ProductImages({
    Key? key,
    required this.imgList,
    required this.currentIndex,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Helper.screenHeight(context) * 0.5,
      width: Helper.screenWidth(context) * 0.9,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    imgList[currentIndex],
                    fit: BoxFit.cover,
                  ),
                ),
              )),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: imgList.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onImageSelected(index),
                  child: Container(
                    width: Helper.screenWidth(context)*0.2,
                    height: Helper.screenHeight(context)*0.02,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            currentIndex == index ? Colors.black : Colors.grey,
                        width: currentIndex == index ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image(
                        image: AssetImage(imgList[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
