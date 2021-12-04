import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_desk/models/user_model.dart';
import 'package:my_desk/pages/home_page.dart';


class EditProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const EditProfile(
      {Key? key, required this.userModel, required this.firebaseUser})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? imageFile;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController studentIDController = TextEditingController();

  void selectImage(ImageSource source) async {
    XFile? selectedImage = await ImagePicker().pickImage(source: source);
    if (selectedImage != null) {
      cropImage(selectedImage);
    }
  }

  void cropImage(XFile file) async {
    File? croppedImage = await ImageCropper.cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 10,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = croppedImage;
      });
    }
  }

  void showImageOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Upload profile picture",
            style: TextStyle(
              color: Colors.blueGrey,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.gallery);
                },
                leading: const Icon(Icons.photo_album_rounded),
                title: const Text(
                  "Select from Gallery",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  selectImage(ImageSource.camera);
                },
                leading: const Icon(CupertinoIcons.photo_camera),
                title: const Text(
                  "Take new photo",
                  style: TextStyle(
                    color: Colors.blueGrey,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void checkValues() {
    String fullName = fullNameController.text.trim();
    String studentID = studentIDController.text.trim();

    if (fullName.isEmpty || imageFile == override || studentID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 1),
          content: Text("Please fill all the fields!"),
        ),
      );
    } else {
      uploadData();
    }
  }

  void uploadData() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepictures")
        .child(widget.userModel.uid.toString())
        .putFile(imageFile!);

    TaskSnapshot snapshot = await uploadTask;

    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullname = fullNameController.text.trim();
    

    widget.userModel.fullName = fullname;
    widget.userModel.profilePic = imageUrl;


    await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userModel.uid)
        .set(widget.userModel.toMap())
        .then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueGrey,
            duration: Duration(seconds: 1),
            content: Text("Profile Updated"),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage(
                  userModel: widget.userModel,
                  firebaseUser: widget.firebaseUser);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.pink[900],
        title: const Text(
          "Edit Profile",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CupertinoButton(
              onPressed: () {
                showImageOptions();
              },
              child: CircleAvatar(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.blueAccent,
                radius: 60,
                backgroundImage:
                    (imageFile != null) ? FileImage(imageFile!) : null,
                child: (imageFile == null)
                    ? const Icon(
                        Icons.person,
                        size: 60,
                      )
                    : null,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
              child: Flexible(
                child: Column(
                  children: [
                    TextField(
                      controller: fullNameController,
                      
                      decoration: const InputDecoration(
                          labelText: "Full name:", hintText: "Enter full name"),
                    ),
                    TextField(
                      controller: studentIDController, 
                      decoration: const InputDecoration(
                          labelText: "Student ID:",
                          hintText: "Enter student ID:"),
                          
                    ),
                  ],
                ),
              ),
            ),
            CupertinoButton(
              onPressed: () {
                checkValues();
              },
              child: const Text(
                "Submit",
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
