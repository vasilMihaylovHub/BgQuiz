
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/components/text_field.dart';
import 'package:quiz_maker/services/credentials_service.dart';
import '../models/service_account_type.dart';

class ChatState with ChangeNotifier {
  List<Content> chatMessages = [];

  void addMessage(Content message) {
    chatMessages.add(message);
    notifyListeners();
  }
}

class ChatBottomSheet extends StatefulWidget {
  final String geminiKey;

  ChatBottomSheet(this.geminiKey);

  @override
  _ChatBottomSheetState createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro', apiKey: widget.geminiKey,
    );
    _chat = _model.startChat();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 750),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  Future<void> _sendChatMessage(String message) async {
    setState(() {
      _loading = true;
      _textController.clear();
      _textFieldFocus.unfocus();
      _scrollDown();
    });

    List<Part> parts = [];
    var response = _chat.sendMessageStream(Content.text(message));
    await for (var item in response) {
      var text = item.text;
      setState(() {
        _loading = false;
        parts.add(TextPart(text!));
        context.read<ChatState>().addMessage(Content('model', parts));
      });
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 3),
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Colors.deepPurple, Colors.blueAccent, Colors.cyan],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.4),
                    blurRadius: 12,
                    spreadRadius: 4,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: MyTextField(
                  text: 'Чат с изкуствен интелект',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Consumer<ChatState>(
                builder: (context, chatState, child) {
                  return ListView.separated(
                    controller: _scrollController,
                    itemCount: chatState.chatMessages.length,
                    reverse: false,
                    itemBuilder: (context, index) {
                      var content = chatState.chatMessages[index];
                      var text = content.parts
                          .whereType<TextPart>()
                          .map<String>((e) => e.text)
                          .join('');
                      return ListTile(

                        title: Text(getTextWithPrefix(text, content.role), style: TextStyle(
                            color: content.role == ChatRole.user.name
                                ? Theme.of(context).colorScheme.inversePrimary
                                : Colors.blue)),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 15);
                    },
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: TextField(
                      cursorColor: Colors.blue,
                      controller: _textController,
                      focusNode: _textFieldFocus,
                      decoration: InputDecoration(
                        hintText: 'Попитай ме нещо...',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primary,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    final message = _textController.text;
                    if (message.isNotEmpty) {
                      context.read<ChatState>().addMessage(
                        Content(ChatRole.user.name, [TextPart(message)]),
                      );
                      _sendChatMessage(message);
                    }
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 1),
                          blurRadius: 3,
                          spreadRadius: 3,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),
                    child: _loading
                        ? const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      ),
                    )
                        : const Icon(Icons.send_rounded, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getTextWithPrefix(String text, String? role) {
    if(role == ChatRole.user.name){
      return 'Me: '+ text;
    }
    return 'AI: '+ text;
  }
}

Future<void> openChatBottomSheet(BuildContext context) async {

  Map<String, dynamic>? tokenMap = await CredentialsService().getToken(TokenType.gemini_api_key);
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
    builder: (context) {
      return ChangeNotifierProvider(
        create: (context) => ChatState(),
        child: ChatBottomSheet(tokenMap!['token']),
      );
    },
  );
}


enum ChatRole {
  user,
  ai
}
