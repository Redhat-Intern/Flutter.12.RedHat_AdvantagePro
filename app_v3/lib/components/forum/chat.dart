import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../model/forum.dart';
import '../../model/user.dart';
import '../../providers/user_detail_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/network_image.dart';
import '../common/text.dart';
import 'chatting_page.dart';

class Chat extends ConsumerWidget {
  const Chat({
    super.key,
    required this.data,
    required this.index,
    required this.isLast,
  });

  final ChatForum data;
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel userData = ref.watch(userDataProvider).key;
    ChatMessage message = data.messages.last;
    String lastMessage = message.text != null
        ? message.text!
        : message.imageURL != null
            ? "Image is sent .."
            : message.type == MessageType.audio
                ? "Audio is sent .."
                : message.type == MessageType.video
                    ? "Video is sent .."
                    : "${message.specType!.toUpperCase()} is sent ..";
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    String imagePath = data.imageURL;
    String? senderID;

    if (imagePath.isEmpty) {
      String email =
          userData.userRole == UserRole.superAdmin ? "admin" : userData.email;
      data.members.forEach((key, value) {
        if (key != email) {
          imagePath = value["imagePath"];
          senderID = key;
        }
      });
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChattingPage(
              index: index,
              senderID: senderID,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(top: height * 0.01),
        child: Column(
          children: [
            Row(
              children: [
                CustomNetworkImage(
                  size: aspectRatio * 120,
                  radius: 8,
                  url: imagePath,
                  rightMargin: width * 0.02,
                  padding: 1.5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: data.name.toString()[0].toUpperCase() +
                            data.name.toString().substring(1),
                        weight: FontWeight.w800,
                        size: sizeData.medium,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      CustomText(
                        text: lastMessage,
                        weight: FontWeight.w600,
                        size: sizeData.small,
                        color: colorData.fontColor(.6),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Container(
                    //   padding: EdgeInsets.all(aspectRatio * 10),
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     gradient: LinearGradient(
                    //       colors: [
                    //         colorData.primaryColor(.3),
                    //         colorData.primaryColor(1),
                    //       ],
                    //     ),
                    //   ),
                    //   child: CustomText(
                    //     text: "3",
                    //     color: colorData.secondaryColor(1),
                    //     weight: FontWeight.w700,
                    //   ),
                    // ),
                    CustomText(
                      text: DateFormat.Hm().format(message.time),
                      weight: FontWeight.w800,
                      color: colorData.fontColor(.8),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: height * 0.0125,
            ),
            if (isLast)
              Container(
                height: 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      colorData.fontColor(.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
