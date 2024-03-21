import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

Widget indicator(BuildContext context) {
  return  LoadingIndicator(
      indicatorType: Indicator.ballClipRotatePulse, /// Required, The loading type of the widget
      colors: [Theme.of(context).colorScheme.secondary],       /// Optional, The color collections
      strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
      pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
  );
}