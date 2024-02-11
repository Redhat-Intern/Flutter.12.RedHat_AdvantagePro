import 'package:flutter/material.dart';

import '../../../utilities/theme/size_data.dart';
import '../../../pages/create_batch.dart';

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
          horizontal: width * 0.2,
          vertical: height*0.02
        ),
        padding: EdgeInsets.symmetric(vertical: height * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/create_bath.png"),
          ),
        ),
        child: Center(
          child: Text(
            "Create \n a Certification\n Batch",
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: sizeData.subHeader,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
