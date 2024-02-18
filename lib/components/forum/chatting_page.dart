import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/providers/chat_scroll_provider.dart';

import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import 'chat_page/chat_message.dart';
import 'chat_page/chat_page_header.dart';
import 'chat_page/chat_textfield.dart';

class ChattingPage extends ConsumerStatefulWidget {
  const ChattingPage({super.key});

  @override
  ConsumerState<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends ConsumerState<ChattingPage> {
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ref.watch(chatScrollProvider);

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
              const ChatFieldHeader(
                name: "RHCSA001",
                imageURL: "assets/images/staff1.png",
                status: Status.online,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Expanded(
                child: ListView.builder(
                    dragStartBehavior: DragStartBehavior.down,
                    reverse: true,
                    controller: controller,
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.01,
                      horizontal: width * 0.03,
                    ),
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return ChatMessage(
                        senderId: index % 2 == 0 ? "Hi" : "iH",
                        receiverId: "Hello",
                        time: DateTime.now(),
                        type: MessageType.image,
                        message:
                            "Hello, how are you? This is Bharathraj N fom csec ",
                        imageURL: "assets/images/create_bath.png",
                      );
                    }),
              ),
              const ChatTextField(),
            ],
          ),
        ),
      ),
    );
  }
}
