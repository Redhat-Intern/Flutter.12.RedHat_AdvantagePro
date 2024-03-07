import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:redhat_v1/utilities/static_data.dart';

import '../../providers/user_select_provider.dart';
import '../../utilities/theme/size_data.dart';
import '../common/text.dart';

class UserSelect extends ConsumerWidget {
  const UserSelect({
    super.key,
    required this.togo,
    required this.text,
    required this.shaderColors,
    this.size,
    this.hpad,
    required this.role,
  });

  final Widget togo;
  final String text;
  final List<Color> shaderColors;
  final double? size;
  final double? hpad;
  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    return GestureDetector(
      onTap: () {
        ref.read(userRoleProvider.notifier).setUserRole(role);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => togo,
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(
            horizontal: hpad ?? width * 0.06, vertical: height * 0.01),
        child: ShaderMask(
          shaderCallback: (Rect rect) =>
              LinearGradient(colors: shaderColors).createShader(rect),
          child: CustomText(
            text: text,
            size: size ?? sizeData.header,
            weight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
