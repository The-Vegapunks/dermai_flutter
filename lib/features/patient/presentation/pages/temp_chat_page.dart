import 'package:dermai/features/core/entities/message.dart';
import 'package:dermai/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;

class TempChatPage extends StatefulWidget {
  final String diagnosedID;
  final String diseaseName;
  final String initialMessage;
  const TempChatPage(
      {super.key, required this.diagnosedID, required this.diseaseName, required this.initialMessage});

  @override
  State<TempChatPage> createState() => _TempChatPageState();
}

class _TempChatPageState extends State<TempChatPage> {
  List<Message> _messages = [];
  List<types.Message> messages = [];

  final types.User me = const types.User(id: '1');
  final types.User gemini = const types.User(id: '2', firstName: 'DermAI');

  @override
  void initState() {
    messages.add(types.TextMessage(
      id: '',
      text: widget.initialMessage,
      author: gemini
    ));
    context
        .read<PatientBloc>()
        .add(PatientListenMessages(diagnosedID: widget.diagnosedID));
    super.initState();
  }

  void updateMessages() {
    setState(() {
      if (_messages.length > messages.length) {
        messages = _messages
            .map((e) => types.TextMessage(
                  id: e.messageID,
                  text: e.message,
                  author: e.isGenerated ? gemini : me,
                ))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is PatientSuccessGetMessages) {
          setState(() {
            _messages = state.messages;
            updateMessages();
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('AI Assistant'),),
          body: AbsorbPointer(
            absorbing: state is PatientTyping,
            child: SafeArea(
              child: chat_ui.Chat(
                  messages: messages,
                  typingIndicatorOptions:
                      chat_ui.TypingIndicatorOptions(typingUsers: state is PatientTyping ? [gemini] : []),
                  theme: chat_ui.DefaultChatTheme(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    primaryColor: Theme.of(context).colorScheme.primaryContainer,
                    inputBackgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    secondaryColor: Theme.of(context).colorScheme.secondaryContainer,
                    errorColor: Theme.of(context).colorScheme.error,
                    inputTextColor: Theme.of(context).colorScheme.onSurface,
                    receivedMessageBodyTextStyle: Theme.of(context).textTheme.bodyMedium!,
                    receivedMessageBodyBoldTextStyle: Theme.of(context).textTheme.bodyLarge!,
                    sentMessageBodyTextStyle: Theme.of(context).textTheme.bodyMedium!,
                    sentMessageBodyBoldTextStyle: Theme.of(context).textTheme.bodyLarge!
                  ),
                  onSendPressed: (text) => {
                        setState(() {
                          _messages = [
                            Message(
                                messageID: '',
                                dateTime: DateTime.now(),
                                isGenerated: false,
                                diagnosedID: widget.diagnosedID,
                                message: text.text.trim()),
                            ..._messages,
                          ];
                          updateMessages();
                        }),
                        context.read<PatientBloc>().add(PatientSendMessageEvent(
                            diagnosedID: widget.diagnosedID,
                            diseaseName: widget.diseaseName,
                            previousMessages: _messages)),
                      },
                  user: me),
            ),
          ),
        );
      },
    );
  }
}
