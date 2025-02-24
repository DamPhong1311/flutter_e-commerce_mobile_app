import 'package:ecommerece_flutter_app/common/validators/validators.dart';
import 'package:flutter/material.dart';

import '../../constants/sized_box.dart';

class TextFormFieldCustom {
  TextFormFieldCustom._();

  static Widget textFormField(
      {required TextEditingController controller,
      required String text,
      required String label,
      required BuildContext context, String? fieldName}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: Theme.of(context).textTheme.titleLarge),
        KSizedBox.smallHeightSpace,
        TextFormField(
          validator: (value) => VValidators.validateEmptyText(fieldName, value),
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
