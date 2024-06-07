import 'package:flutter/material.dart';
import 'package:flutter_gemini_chat/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<MessageModel> _messages = <MessageModel>[];
  bool _isLoading = false;

  final APIService _apiService = APIService();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {});
    });
    _apiService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Chat'),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Type a message',
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _textEditingController.text.isEmpty
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true;
                        _messages.add(MessageModel(
                          message: _textEditingController.text,
                          isSent: true,
                        ));
                        _textEditingController.clear();
                      });

                      String? response = await _apiService.generateText(
                        prompt: _messages.last.message,
                      );
                      setState(() {
                        _isLoading = false;
                        _messages.add(MessageModel(
                          message: response ?? 'No response',
                          isSent: false,
                        ));
                      });
                    },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                        child: Text(
                          'Start a conversation!',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      )
                    : ListView.separated(
                        itemCount: _messages.length + (_isLoading ? 1 : 0),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          if (_isLoading && index == _messages.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final message = _messages[index];
                          return Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            child: ListTile(
                              tileColor: message.isSent
                                  ? Colors.grey[200]
                                  : Colors.purple[100],
                              title: Text(message.message),
                              subtitle: Text(
                                message.time.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: message.isSent
                                  ? const Icon(Icons.done)
                                  : const Icon(Icons.done_all),
                            ),
                          );
                        },
                      ),
              ),
              const Divider(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageModel {
  final String message;
  final bool isSent;
  final DateTime time = DateTime.now();

  MessageModel({
    required this.message,
    required this.isSent,
  });
}
