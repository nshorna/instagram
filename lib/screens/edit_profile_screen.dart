import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:instagram_clone/services/permission_service.dart';
import 'package:instagram_clone/models/user_model.dart';
import 'package:instagram_clone/services/database_service.dart';
import 'package:instagram_clone/services/storage_service.dart';
// import 'package:permission_handler/permission_handler.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;

  EditProfileScreen({this.user});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '', _bio = '';
  File _profileImage;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _bio = widget.user.bio;
  }

  _displayProfileImage() {
    if (_profileImage == null) {
      if (widget.user.profileImageUrl.isEmpty) {
        return AssetImage('assets/images/user_placeholder.png');
      } else {
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    } else {
      return FileImage(_profileImage);
    }
  }

  _handleImageFromGallery() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      if (this.mounted) {
        setState(() {
          _profileImage = imageFile;
        });
      }
    }
  }

  _handleImageFromCamera() async {
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      if (this.mounted) {
        setState(() {
          _profileImage = imageFile;
        });
      }
    }
  }

  _submit() async {
    if (_formKey.currentState.validate() && !isLoading) {
      _formKey.currentState.save();

      if (this.mounted) {
        setState(() {
          isLoading = true;
        });
      }
      //Update user in database
      String _profileImageUrl = '';
      if (_profileImage == null) {
        _profileImageUrl = widget.user.profileImageUrl;
      } else {
        _profileImageUrl = await StorageService.uploadUserProfileImage(
            widget.user.profileImageUrl, _profileImage);
      }

      User user = User(
        id: widget.user.id,
        name: _name,
        profileImageUrl: _profileImageUrl,
        bio: _bio,
      );

      //Database Update
      DatabaseService.updateUser(user);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView(
          children: <Widget>[
            isLoading
                ? LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  )
                : SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey,
                      backgroundImage: _displayProfileImage(),
                    ),
                    FlatButton(
                      onPressed: _handleImageFromGallery,
                      child: Text(
                        'Change Profile Image',
                        style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 16.0),
                      ),
                    ),
                    TextFormField(
                      initialValue: _name,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                          icon: Icon(Icons.person), labelText: 'Name'),
                      validator: (input) => input.trim().length < 1
                          ? 'Please enter a valid name'
                          : null,
                      onSaved: (input) => _name = input,
                    ),
                    TextFormField(
                      initialValue: _bio,
                      style: TextStyle(fontSize: 18.0),
                      decoration: InputDecoration(
                          icon: Icon(Icons.book), labelText: 'Bio'),
                      validator: (input) => input.trim().length > 150
                          ? 'Please enter a bio less that 150 characters'
                          : null,
                      onSaved: (input) => _bio = input,
                    ),
                    Container(
                      margin: EdgeInsets.all(14.0),
                      height: 50,
                      width: 250,
                      child: FlatButton(
                        color: Colors.blue,
                        onPressed: isLoading ? null : _submit,
                        disabledColor: Colors.grey,
                        child: Text(
                          'Save Profile',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
