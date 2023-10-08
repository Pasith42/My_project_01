import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onPickImage});

  final void Function(File image) onPickImage;

  @override
  State<ImageInput> createState() {
    return _ImageInputState();
  }
}

class _ImageInputState extends State<ImageInput> {
  File? _selectedImage;

  Future _takePicture(ImageSource source) async {
    try {
      final imagePicker = ImagePicker();
      final pickedImage =
          await imagePicker.pickImage(source: source, maxWidth: 600);

      if (pickedImage == null) {
        return;
      }

      //final imageTemporary = File(pickedImage.path);
      final imagePermanent = await saveImagePermanently(pickedImage.path);

      setState(() {
        _selectedImage = imagePermanent;
      });

      widget.onPickImage(_selectedImage!);
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Camera'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        TextButton.icon(
            onPressed: () => _takePicture(ImageSource.camera),
            icon: const Icon(Icons.camera),
            label: const Text('Take Picture from camera')),
        const SizedBox(
          height: 30,
        ),
        TextButton.icon(
            onPressed: () => _takePicture(ImageSource.gallery),
            icon: const Icon(Icons.image_outlined),
            label: const Text('Take Picture from gallery')),
      ],
    );

    if (_selectedImage != null) {
      content = GestureDetector(
        onTap: () async {
          final source = await showImageSource(context);

          _takePicture(source!);
        },
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }

    return Container(
        height: 250,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
        ),
        child: content);
  }
}
