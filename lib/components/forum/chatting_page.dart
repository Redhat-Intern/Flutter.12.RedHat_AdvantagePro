import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/forum.dart';
import '../../providers/chat_scroll_provider.dart';
import '../../providers/forum_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import 'chat_page/chat_message.dart';
import 'chat_page/chat_page_header.dart';
import 'chat_page/chat_textfield.dart';

class ChattingPage extends ConsumerStatefulWidget {
  const ChattingPage({super.key, required this.index});
  final int index;

  @override
  ConsumerState<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends ConsumerState<ChattingPage> {
  @override
  void didUpdateWidget(covariant ChattingPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    ScrollController controller = ref.watch(chatScrollProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.jumpTo(controller.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ref.watch(chatScrollProvider);
    ChatForum chatForum = ref.watch(forumDataProvider)[widget.index];
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      drawerEnableOpenDragGesture: true,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            children: [
              ChatFieldHeader(
                name: chatForum.name,
                imageURL: chatForum.imageURL,
                status: Status.online,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: ListView.builder(
                    // dragStartBehavior: DragStartBehavior.down,
                    controller: controller,
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.01,
                      horizontal: width * 0.03,
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: chatForum.messages.length,
                    itemBuilder: (context, index) {
                      ChatMessage message = chatForum.messages[index];
                      return ChatTile(
                        senderId: message.from,
                        name: message.name,
                        receiverId: message.to ?? "all",
                        isGroup: chatForum.members.length > 2,
                        time: message.time,
                        type: message.type,
                        message: message.text,
                        imageURL: message.imageURL,
                        fileURL: message.fileURL,
                      );
                    }),
              ),
              ChatTextField(index: widget.index),
            ],
          ),
        ),
      ),
    );
  }
}
