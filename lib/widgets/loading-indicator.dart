import 'package:flutter/material.dart';
import 'package:pds/widgets/indicator.dart';

void loadingIndicator(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) =>  Center(
      child: indicator(context),
    ),
  );
}
