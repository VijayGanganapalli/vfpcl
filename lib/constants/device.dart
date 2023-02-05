import 'package:flutter/material.dart';

class Device {
  double width(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    if (deviceWidth <= 500) {
      return MediaQuery.of(context).size.width;
    } else if (deviceWidth >= 500 && deviceWidth <= 800) {
      return MediaQuery.of(context).size.width / 2;
    } else if (deviceWidth >= 800 && deviceWidth <= 1200) {
      return MediaQuery.of(context).size.width / 3;
    } else if (deviceWidth >= 1200 && deviceWidth <= 1600) {
      return MediaQuery.of(context).size.width / 4;
    } else if (deviceWidth >= 1600 && deviceWidth <= 2500) {
      return MediaQuery.of(context).size.width / 5;
    }
    return MediaQuery.of(context).size.width;
  }
}
