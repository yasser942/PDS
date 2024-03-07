import 'package:flutter/material.dart';

class GeminiChatUI extends StatefulWidget {
  @override
  _GeminiChatUIState createState() => _GeminiChatUIState();
}

class _GeminiChatUIState extends State<GeminiChatUI> {
  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  // Method to add a new message (replace with Gemini call later)
  void _sendMessage(String text) {
    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUser: true));
      // TODO: Fetch Gemini's response and add it as a new ChatMessage
    });
    _messageController.clear();
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
                    onSubmitted: (text) => _sendMessage(text),
                    decoration: const InputDecoration.collapsed(hintText: 'Send a message'),
                  ),
                ),
                IconButton(


                  icon: Icon(Icons.send,color: _messageController.text.isEmpty ? Colors.grey : Colors.green[300]),
                  onPressed: () => _messageController.text.isEmpty ? null : _sendMessage(_messageController.text),
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

  ChatMessage({required this.text, required this.isUser});

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
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

