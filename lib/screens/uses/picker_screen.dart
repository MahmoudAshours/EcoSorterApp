import 'package:ecosorter/screens/constants.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class PickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: kPrimaryColor,
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text('Eco Sorter'),
    );
  }
}
