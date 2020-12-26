import 'package:animate_do/animate_do.dart';
import 'package:dio/dio.dart';
import 'package:ecosorter/screens/bluetooth/blue_home.dart';
import 'package:ecosorter/screens/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';

class Classification extends StatefulWidget {
  final imagePath;
  Classification(this.imagePath);

  @override
  _ClassificationState createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  var _data;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: Text('Classifying'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
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
                  Center(
                    child: FutureBuilder(
                      future:
                          Future.delayed(Duration(seconds: 1), makePostRequest),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return !snapshot.hasData ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                widget.imagePath == null
                            ? SpinKitCubeGrid(
                                size: 51.0,
                                itemBuilder: (BuildContext context, int i) {
                                  return DecoratedBox(
                                    decoration: BoxDecoration(
                                      color:
                                          i.isOdd ? Colors.blue : Colors.black,
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Container(
                                  width: 300,
                                  height: 400,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      FadeInUp(
                                        delay: Duration(seconds: 1),
                                        animate: true,
                                        child: Text(
                                          '${snapshot.data}',
                                          style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Divider(thickness: 0.4),
                                      FadeInUp(
                                        delay: Duration(
                                            seconds: 1, milliseconds: 800),
                                        animate: true,
                                        child: InkWell(
                                          onTap: () =>
                                              Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  BlueHome(snapshot.data),
                                            ),
                                          ),
                                          splashColor: Colors.blue,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.bluetooth,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  'Send it to Bluetooth device!',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePostRequest() async {
    const url = "https://flutterpython.pythonanywhere.com/API";

    Dio dio = Dio();
    FormData formData = new FormData.fromMap({
      "file": await MultipartFile.fromFile(widget.imagePath,
          filename: "${basename(widget.imagePath)}"),
    });
    Response response = await dio.post(url, data: formData);

    _data = classify(response.data);
    return _data;
  }

  String classify(result) {
    switch (result) {
      case '0':
        return 'Glass';
        break;
      case '1':
        return 'Metal';
        break;
      case '2':
        return 'Paper';
        break;
      case '3':
        return 'Plastic';
        break;
      default:
        return 'None';
    }
  }
}
