import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gemini_flutter/gemini_flutter.dart';

class GeminiChatUI extends StatefulWidget {
  const GeminiChatUI({Key? key}) : super(key: key);

  @override
  _GeminiChatUIState createState() => _GeminiChatUIState();
}

class _GeminiChatUIState extends State<GeminiChatUI> {
  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool isWaitingForResponse = false; // Add this line

  // Method to add a new message and get Gemini's response
  void _sendMessage(String text) async {
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
      isWaitingForResponse = true; // Add this line
    });
    _messageController.clear();

    // Get Gemini's response
    String geminiResponse = await getGeminiResponse(text);

    setState(() {
      _messages.insert(0, ChatMessage(text: geminiResponse, isUser: false));
      isWaitingForResponse = false; // Add this line
    });
  }

  Future<String> getGeminiResponse(String userMessage) async {
    String textData = "";
    final response = await GeminiHandler().geminiPro(text: userMessage);
    textData = response?.candidates?.first.content?.parts?.first.text ??
        "Failed to fetch data";
    return textData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (text) => setState(() {}),
                    controller: _messageController,
                    onSubmitted: (text) =>
                    isWaitingForResponse ? null : _sendMessage(text), // Modify this line
                    decoration: const InputDecoration.collapsed(
                        hintText: 'Send a message'),
                    enabled: !isWaitingForResponse, // Add this line
                  ),
                ),
                IconButton(
                  icon: isWaitingForResponse
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                      : Icon(
                    Icons.send,
                    color: _messageController.text.isEmpty
                        ? Colors.grey
                        : Colors.green[300],
                  ),
                  onPressed: () => _messageController.text.isEmpty ||
                      isWaitingForResponse
                      ? null
                      : _sendMessage(_messageController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Simple data class to represent a chat message
class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({Key? key, required this.text, required this.isUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? Colors.green[300] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isUser ? 20 : 5),
            topRight: Radius.circular(isUser ? 5 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser)
              Icon(
                Icons.rocket_launch_outlined,
                color: Theme.of(context).colorScheme.secondary,
                size: 25,
              ),
            if(isUser) Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.secondary,
              size: 25,
            ),
            MarkdownBody(
              data: text,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
