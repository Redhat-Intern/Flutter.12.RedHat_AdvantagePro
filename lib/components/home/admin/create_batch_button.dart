import 'package:flutter/material.dart';
import 'package:redhat_v1/components/common/text.dart';

import '../../../pages/batch/create_batch.dart';
import '../../../utilities/theme/size_data.dart';

class CreateBatchButton extends StatelessWidget {
  const CreateBatchButton({super.key});

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const CreateBatch(),
        ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.2, vertical: height * 0.02),
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        height: height * .1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/create_batch.png"),
          ),
        ),
        alignment: Alignment.center,
        child: CustomText(
          text: "CREATE BATCH",
          color: Colors.white,
          size: sizeData.subHeader,
          fontFamily: "Merriweather",
        ),
      ),
    );
  }
}
