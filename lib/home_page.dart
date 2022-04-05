import 'dart:io';
import 'dart:math';
import 'package:cam_gallery/HiveCLass/gallery.dart';
import 'package:cam_gallery/createpath.dart';
import 'package:cam_gallery/display_image.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Random random = Random();
  int count= 1;
  XFile? _imageFile;

  

  chooseImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _imageFile = pickedFile;
      Hive.box<Gallery>('gallery').add(Gallery(
        imagePath: pickedFile!.path
      ));
      count=random.nextInt(198127467);
    });
    File(_imageFile!.path).copy('${dir!.path}/CamImage0$count.jpeg');
      count++;
      
  }


  @override
  void initState() {
    createpath();
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Gallery'),
          centerTitle: true,
          elevation: 10,
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<Gallery>('gallery').listenable(),
          builder: (context, Box<Gallery> box, widget) {
            List keys = box.keys.toList();
            if (keys.isEmpty) {
              return const Center(
                child: Text('Take snaps'),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: ((context, index) {
                List<Gallery>? data = box.values.toList();
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DisplayImage(
                              length: data.length,
                              image: data[index].imagePath,
                              index: index,
                            )));
                  },
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              content: const Text('Delete the image?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('CANCEL'),
                                ),
                                TextButton(
                                    onPressed: () {
                                      data[index].delete();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK')),
                              ],
                            ));
                  },
                  child: Container( 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Colors.purple,
                          width: 0.5,
                          style: BorderStyle.solid),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(
                          File(
                            data[index].imagePath!,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              itemCount: keys.length,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              chooseImage(ImageSource.camera);
            },
            child: const Icon(Icons.camera_alt))
            ,
            );
  }
}