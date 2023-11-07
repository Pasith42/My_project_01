import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _file;

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      final file =
          File("${(await getApplicationDocumentsDirectory()).path}/image.png");
      await file.writeAsBytes(await image.readAsBytes());
      setState(() => _file = file); // `_file = image` works though
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: _pickImage,
          child: const Icon(Icons.camera_alt)),
      body: _file == null ? Container() : Image.file(_file!),
    );
  }
}
