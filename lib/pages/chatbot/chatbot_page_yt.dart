import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ecommerece_flutter_app/common/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/product.dart';
import '../product_detail/product_detail.dart';

const String openRouterApiKey =
    'Bearer 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';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Phong', lastName: 'Dam');
  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'Chat', lastName: 'Bot');

  List<ChatMessage> _messages = [];
  List<ChatUser> _typingUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: KColors.primaryColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Chatbot',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: DashChat(
        currentUser: _currentUser,
        typingUsers: _typingUsers,
        messageOptions: MessageOptions(
          currentUserContainerColor: const Color.fromARGB(98, 0, 0, 0),
          containerColor: KColors.primaryColor,
          textColor: Colors.white,
          parsePatterns: [
            MatchText(
              type: ParsedType.URL,
              style: const TextStyle(
                color: Colors.yellowAccent,
                decoration: TextDecoration.underline,
              ),
              onTap: (url) => _handleLink(url),
            ),
            MatchText(
              pattern: r'(product://detail/\w+)',
              style: const TextStyle(
                color: Colors.lightBlueAccent,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
              ),
              onTap: (url) => _handleLink(url),
            ),
          ],
        ),
        onSend: (ChatMessage message) {
          getChatResponse(message);
        },
        messages: _messages,
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage userMessage) async {
    setState(() {
      _messages.insert(0, userMessage);
      _typingUsers.add(_gptChatUser);
    });

    try {
      final productLines = await fetchProductPromptLines();

      final productTextList = productLines.map((product) {
        final id = product['id'];
        final name = product['name'];
        final desc = product['description'];
        final price = product['price'];
        final sale = product['salePercent'];

        return '''
Sản phẩm:
- name: $name
- Price: ${price}đ
- Discount: $sale%
- Link: product://detail/$id
''';
      }).join("\n");

      final systemPrompt = '''
You are a helpful e-commerce assistant.

Only recommend products from the list below (just 3 product each respone). For each product, when introducing it to the user:
- Write a short, friendly description
- Include the price (write as: "Price: ... VND")
- If there's a discount, include it too (e.g., "Discount: 20%")
- Most importantly: attach the product link using the exact format: product://detail/[product_id]
    - The link **must match the product being described**, do NOT invent or mix up product IDs.

Here is the product list:
$productTextList
''';

      final messageHistory = [
        {
          'role': 'system',
          'content': systemPrompt,
        },
        ..._messages.reversed.take(10).map((m) => {
              'role': m.user.id == _currentUser.id ? 'user' : 'assistant',
              'content': m.text,
            }),
      ];

      final response = await http.post(
        Uri.parse("https://openrouter.ai/api/v1/chat/completions"),
        headers: {
          'Authorization': openRouterApiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'mistralai/mistral-7b-instruct:free',
          'messages': messageHistory,
          'max_tokens': 500,
        }),
      );

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && decoded['choices'] != null) {
        final reply = decoded['choices'][0]['message']['content'];
        setState(() {
          _messages.insert(
            0,
            ChatMessage(
              user: _gptChatUser,
              createdAt: DateTime.now(),
              text: reply,
            ),
          );
        });
      } else {
        _handleError("Lỗi API: $decoded");
      }
    } catch (e) {
      _handleError("Lỗi: $e");
    } finally {
      setState(() {
        _typingUsers.remove(_gptChatUser);
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchProductPromptLines() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').limit(100).get();

    List<Map<String, dynamic>> productDataList = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      productDataList.add({
        "id": doc.id,
        "name": data['name'] ?? '',
        "description": data['description'] ?? '',
        "price": data['priceProduct'] ?? '',
        "salePercent": data['salePercent'] ?? '',
        "link": "product://detail/${doc.id}",
      });
    }

    return productDataList;
  }

  void _handleError(String errorMessage) {
    setState(() {
      _messages.insert(
        0,
        ChatMessage(
          user: _gptChatUser,
          createdAt: DateTime.now(),
          text: errorMessage,
        ),
      );
    });
  }

  void _handleLink(String url) async {
    if (url.startsWith("product://detail/")) {
      final productId = url.split("/").last;
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .get();

      if (!doc.exists) return;

      final product = Product.fromMap(doc.data()!, doc.id);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetail(
            rateProduct: "4.8",
            product: product,
          ),
        ),
      );
    } else if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
