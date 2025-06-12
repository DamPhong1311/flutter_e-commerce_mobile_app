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
      ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');

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
          currentUserContainerColor: Colors.black,
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

      final systemPrompt = '''
Bạn là trợ lý bán hàng cho một app thương mại điện tử. 
Chỉ được giới thiệu những sản phẩm sau đây, đính kèm mô tả, giá và link:

${productLines.map((e) => "- $e").join("\n")}
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

      final decoded = jsonDecode(response.body);

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

  Future<List<String>> fetchProductPromptLines() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('products').limit(5).get();

    List<String> lines = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final name = data['name'] ?? '';
      final desc = data['description'] ?? '';
      final price = data['priceProduct'] ?? '';
      final salePercent = data['salePercent'] ?? '';
      final productLink = "product://detail/${doc.id}";

      lines.add(
          "$name - $desc. Giá: ${price}đ. Giảm giá: $salePercent. Link: $productLink.");
    }

    return lines;
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
