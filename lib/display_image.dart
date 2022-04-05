import 'dart:io';

import 'package:cam_gallery/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:photo_view/photo_view.dart';

import 'HiveCLass/gallery.dart';

class DisplayImage extends StatelessWidget {
  final String? image;
  final int index;
  final int length;

  const DisplayImage(
      {Key? key,
      required this.image,
      required this.index,
      required this.length})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('back to gallery'),
      ),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: PhotoView(
                  backgroundDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  imageProvider: FileImage(
                    File(image!),
                  ),
                ),
              ),
              ElevatedButton.icon(
                label: const Text('Delete Image'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: const Text(
                                'Do you really want to delete the image?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('NO'),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Hive.box<Gallery>('Gallery')
                                        .deleteAt(index);
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) => const HomeScreen()),
                                        (Route<dynamic> route) => false);
                                  },
                                  child: const Text('YES')),
                            ],
                          ));
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
