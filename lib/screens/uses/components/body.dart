import 'dart:io';

import 'package:ecosorter/screens/classification.dart';
import 'package:ecosorter/screens/camera_screen.dart';
import 'package:ecosorter/screens/constants.dart';
import 'package:ecosorter/screens/uses/components/use_card.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: <Widget>[
          SizedBox(height: kDefaultPadding / 2),
          Expanded(
            child: Stack(
              children: <Widget>[
                // Our background
                Container(
                  margin: EdgeInsets.only(top: 70),
                  decoration: BoxDecoration(
                    color: kBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
                ListView(
                  children: [
                    UseCard(
                      assetImage: 'assets/images/Item_1.png',
                      title: 'Gallery',
                      itemIndex: 1,
                      press: () => getImageFromGallery(context),
                    ),
                    UseCard(
                      assetImage: 'assets/images/Item_2.png',
                      title: 'Camera',
                      itemIndex: 2,
                      press: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) => CameraApp())),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> getImageFromGallery(context) async {
    try {
      File _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => Classification(_image.path)));
    } catch (e) {
      return null;
    }
  }
}
