import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:ecommerece_flutter_app/common/constants/sized_box.dart';
import 'package:ecommerece_flutter_app/common/helper/helper.dart';
import 'package:ecommerece_flutter_app/common/widgets/header/header_container.dart';
import 'package:ecommerece_flutter_app/pages/home/home_page.dart';
import 'package:ecommerece_flutter_app/services/auth_service.dart';
import 'package:flutter/material.dart';

import '../../models/cart_item.dart';
import '../../services/cart_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartService cartService = CartService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: WHeaderContainer.headerContainer(
                    child: SafeArea(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Helper.isDarkMode(context)
                                    ? KColors.lightModeColor
                                    : KColors.dartModeColor,
                              )),
                          KSizedBox.smallWidthSpace,
                          Text(
                            "Your Cart",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .apply(
                                    color: Helper.isDarkMode(context)
                                        ? KColors.lightModeColor
                                        : Colors.white),
                          )
                        ],
                      ),
                    ),
                    height: 150),
              ),
              KSizedBox.heightSpace,
              Expanded(
                flex: 5,
                child: StreamBuilder<List<CartItem>>(
                    stream: cartService.getCartItems(AuthService().getUserId()),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (AuthService().getUserId() == "") {
                        return Text('You are not logged in yet');
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("Giỏ hàng của bạn đang trống"));
                      }

                      final cartItems = snapshot.data!;

                      return ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return infoProductCart(
                              context: context,
                              itemId: item.id,
                              name: item.name,
                              imageUrl: item.imageUrl,
                              total: item.total,
                              priceProduct: item.price,
                              quantity: item.quantity);
                        },
                      );
                    }),
              )
            ],
          ),
          Positioned(
              bottom: 3, // Đặt ở dưới cùng
              left: 1, // Căn trái
              right: 1,
              child: ElevatedButton(
                  onPressed: () {
                    cartService.clearCart(AuthService().getUserId());
                  },
                  child: Text('Delete all product')))
        ],
      ),
    );
  }

  Widget infoProductCart(
      {required BuildContext context,
      required String imageUrl,
      required String name,
      required int priceProduct,
      required int total,
      required String itemId,
      required int quantity}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        width: Helper.screenWidth(context) * 0.95,
        height: Helper.screenHeight(context) * 0.16,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: KColors.dartModeColor.withValues(alpha: 0.1),
                  blurRadius: 50,
                  spreadRadius: 7,
                  offset: Offset(0, 2)),
            ],
            borderRadius: BorderRadius.circular(16),
            color: Helper.isDarkMode(context)
                ? KColors.dartModeColor.withValues(alpha: 0.05)
                : Colors.grey.withValues(alpha: 0.1)),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(8), // Đặt border radius ở đây
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover, // Giúp ảnh vừa khít container
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      KSizedBox.smallHeightSpace,
                      KSizedBox.smallHeightSpace,
                      // KSizedBox.smallHeightSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextPrice(
                            text: Helper.formatCurrency(total),
                            color: Colors.red,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  cartService.removeFromCart(
                                      AuthService().getUserId(),
                                      itemId,
                                      priceProduct);
                                },
                                icon: Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                              ),

                              // Hiển thị số lượng
                              Text(
                                quantity.toString(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                  onPressed: () {
                                    cartService.addToCart(
                                      userId: AuthService().getUserId(),
                                      productId: itemId,
                                      name: name,
                                      price: priceProduct,
                                      imageUrl: imageUrl,
                                    );
                                  },
                                  icon: Icon(Icons.add))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
