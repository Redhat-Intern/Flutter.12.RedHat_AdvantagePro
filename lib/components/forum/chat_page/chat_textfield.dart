import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utilities/theme/color_data.dart';
import '../../../utilities/theme/size_data.dart';
import '../../common/icon.dart';



class ChatTextField extends ConsumerStatefulWidget {
  const ChatTextField({
    super.key,
  });
  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  TextEditingController controller = TextEditingController();

  searchDataFun() {}

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);
    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Container(
      margin: EdgeInsets.only(bottom: height * 0.01, top: height * 0.01),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: height * 0.05,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorData.secondaryColor(.3),
              ),
              child: TextField(
                controller: controller,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    searchDataFun();
                  } else {
                    setState(() {
                      controller.clear();
                    });
                  }
                },
                scrollPadding: EdgeInsets.zero,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: aspectRatio * 33,
                  color: colorData.fontColor(.8),
                  height: 1,
                ),
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: sizeData.medium,
                    color: colorData.fontColor(.5),
                    height: 1,
                  ),
                  contentPadding: EdgeInsets.only(
                      top: height * 0.008,
                      left: width * 0.03,
                      right: width * 0.01),
                  border: InputBorder.none,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      if (controller.text.isNotEmpty) searchDataFun();
                    },
                    child: CustomIcon(
                      icon: Icons.send_rounded,
                      color: colorData.fontColor(.8),
                      size: aspectRatio * 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(aspectRatio * 12),
            margin: EdgeInsets.only(left: width * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: colorData.secondaryColor(.4),
            ),
            child: Icon(
              Icons.attach_file_rounded,
              color: colorData.fontColor(.7),
              size: aspectRatio * 50,
            ),
          ),
        ],
      ),
    );
  }
}
