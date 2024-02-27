import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/functions/update/accept_reject_invitation.dart';
import 'package:redhat_v1/providers/user_detail_provider.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class InvitationMessage extends ConsumerStatefulWidget {
  const InvitationMessage(
      {super.key, required this.batchID, required this.message});

  final String batchID;
  final String message;
  @override
  ConsumerState<InvitationMessage> createState() => _InvitationMessageState();
}

class _InvitationMessageState extends ConsumerState<InvitationMessage> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userData = ref.read(userDataProvider)!;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return AnimatedContainer(
      duration: Durations.medium4,
      margin: EdgeInsets.symmetric(vertical: height * 0.01),
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.015),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorData.secondaryColor(.3),
      ),
      child: AnimatedSize(
        duration: Durations.medium4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => setState(() {
                isExpanded = !isExpanded;
              }),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "Batch ID:",
                          size: sizeData.small,
                          color: colorData.fontColor(.6),
                        ),
                        SizedBox(
                          width: width * 0.01,
                        ),
                        CustomText(
                          text: widget.batchID,
                          weight: FontWeight.w800,
                          size: sizeData.medium,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.005,
                    ),
                    CustomText(
                      text: widget.message,
                      weight: FontWeight.w700,
                      size: sizeData.regular,
                      color: colorData.fontColor(.8),
                      maxLine: 2,
                    ),
                  ],
                ),
              ),
            ),
            isExpanded
                ? Container(
                    margin: EdgeInsets.only(top: height * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            acceptInvitation(
                              email: userData["email"],
                              batchID: widget.batchID,
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                CustomText(
                                  text: "👍",
                                  color: Colors.white,
                                  size: aspectRatio * 40,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.005,
                                      horizontal: width * 0.02),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.green.withOpacity(.8)),
                                  child: const CustomText(
                                    text: "ACCEPT",
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            color: Colors.transparent,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.005,
                                      horizontal: width * 0.02),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Colors.red.withOpacity(.8)),
                                  child: const CustomText(
                                    text: "REJECT",
                                    color: Colors.white,
                                  ),
                                ),
                                CustomText(
                                  text: "👎",
                                  color: Colors.white,
                                  size: aspectRatio * 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}
