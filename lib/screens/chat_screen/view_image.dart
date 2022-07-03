import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sizer/sizer.dart';

class ViewImage extends StatefulWidget {
  ViewImage({Key? key, required this.imageLink}) : super(key: key);
  String imageLink;

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TransformationController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(widget.imageLink),
        ),
      ),
    );
  }
}
