import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petopia/features/domain/entities/user/user_entity.dart';
import 'package:petopia/features/domain/usecases/firebase_usecases/storage/upload_image_to_storage_usecase.dart';
import 'package:petopia/features/presentation/cubit/user/user_cubit.dart';
import 'package:petopia/features/presentation/page/profile/widget/profile_form_widget.dart';
import 'package:petopia/profile_widget.dart';
import 'package:petopia/util/consts.dart';
import 'package:petopia/injection_container.dart' as di;

class EditProfilePage extends StatefulWidget {
  final UserEntity currentUser;

  const EditProfilePage({Key? key, required this.currentUser}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController? _nameController;
  TextEditingController? _usernameController;
  TextEditingController? _websiteController;
  TextEditingController? _bioController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.currentUser.name);
    _usernameController = TextEditingController(text: widget.currentUser.username);
    _websiteController = TextEditingController(text: widget.currentUser.website);
    _bioController = TextEditingController(text: widget.currentUser.bio);
    super.initState();
  }
  bool _isUpdating = false;

  File? _image;

  Future selectImage() async {
    try {
      final pickedFile = await ImagePicker.platform.getImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("no image has been selected");
        }
      });

    } catch(e) {
      toast("some error occured $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlueColor,
      appBar: AppBar(
        backgroundColor: darkBlueColor,
        title: const Text("Edit Profile"),
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.close,
              size: 32,
            )),
        actions:  [
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              onTap: _updateUserProfileData,
              child: Icon(
                Icons.done,
                color: darkBlueColor,
                size: 32,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 120,
                  height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: profileWidget(imageUrl: widget.currentUser.profileUrl, image: _image),
            ),
                  ),
                ),

              sizeVertical(15),
               Center(
                child: GestureDetector(
                  onTap: selectImage,
                  child: Text(
                    "Change profile photo",
                    style: TextStyle(
                        color: darkBlueColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              sizeVertical(15),
               ProfileFormWidget(title: "Name", controller: _nameController,),
              sizeVertical(15),
               ProfileFormWidget(title: "Username", controller: _usernameController),
              sizeVertical(15),
               ProfileFormWidget(title: "Website", controller: _websiteController),
              sizeVertical(15),
               ProfileFormWidget(title: "Bio", controller: _bioController),
              sizeVertical(10),
              _isUpdating == true?Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Please wait...", style: TextStyle(color: Colors.white),),
                  sizeHorizontal(10),
                  CircularProgressIndicator()
                ],
              ) : Container(width: 0, height: 0,)
            ],
          ),
        ),
      ),
    );
  }

  _updateUserProfileData() {
    setState(() => _isUpdating = true);
    if (_image == null) {
      _updateUserProfile("");
    } else {
      di.sl<UploadImageToStorageUseCase>().call(_image!, false, "profileImages").then((profileUrl) {
        _updateUserProfile(profileUrl);
      });
    }
  }

  _updateUserProfile(String profileUrl) {

    BlocProvider.of<UserCubit>(context).updateUser(
        user: UserEntity(
            uid: widget.currentUser.uid,
            username: _usernameController!.text,
            bio: _bioController!.text,
            website: _websiteController!.text,
            name: _nameController!.text,
            profileUrl: profileUrl
        )
    ).then((value) => _clear());
  }

  _clear() {
    setState(() {
      _isUpdating = false;
      _usernameController!.clear();
      _bioController!.clear();
      _websiteController!.clear();
      _nameController!.clear();
    });
    Navigator.pop(context);
  }
}
