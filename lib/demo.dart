import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'modules/notification/notification_api.dart';

class DemoPage extends StatefulWidget {
  const DemoPage({Key? key}) : super(key: key);

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Column(
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: CachedNetworkImage(
            imageUrl: "http://via.placeholder.com/200x150",
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter:
                    const ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
              ),
            ),
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        ElevatedButton(onPressed: (){Notify();}, child: const Text('Press Here')),
      ],
    ),),);
  }
}
