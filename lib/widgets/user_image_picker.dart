import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagepicker extends StatefulWidget{
  const UserImagepicker({super.key,required this.onPickedimage});

  final void Function(File pickedImage) onPickedimage;

  @override
  State<UserImagepicker> createState() {
    return _userimagepicker();
  }
}
class _userimagepicker extends State<UserImagepicker>{
  File? _pickedimagefile;

  void _pickimage()async{
    final pickedimage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 50,
    );

    if(pickedimage==null){
      return ;
    }
    setState(() {
      _pickedimagefile=File(pickedimage.path);
    });
    widget.onPickedimage(_pickedimagefile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor:Colors.grey,
          foregroundImage: _pickedimagefile !=null ? FileImage(_pickedimagefile!): null,
        ),
        TextButton.icon(
            onPressed: _pickimage,
            icon: Icon(Icons.image),
            label: Text(
              'Add Image',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
        )
      ],
    );
  }
}