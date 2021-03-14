import 'dart:io';

import 'package:aadda/Components/InputField.dart';
import 'package:aadda/Modal/UserModal.dart';
import 'package:aadda/Services/DataBaseMethods.dart';
import 'package:aadda/Services/SessionManagement.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../Constants.dart';

class ProfileScreen extends StatefulWidget {
  UserModal user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _userNamecontroller = TextEditingController();
  TextEditingController _aboutcontroller = TextEditingController();
  var imageFile;
  var imageUrl; // from storage
  var size = 140.0;
  final picker = ImagePicker();

  @override
  void initState() {
    _userNamecontroller.text = widget.user.userName;
    _aboutcontroller.text = widget.user.userAbout;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 24,
        title: Text('Profile', style: MediumTextStyle),
        backgroundColor: Colors.grey.shade900,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //ImageView
              GestureDetector(
                onTap: getImage,
                child: Container(
                  child: Center(
                    child: Stack(
                      children: [
                        imageFile == null
                            ? widget.user.userPic != ''
                                ?
                                //load from network
                                Material(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(75.0)),
                                    clipBehavior: Clip.hardEdge,
                                    child: CachedNetworkImage(
                                      imageUrl: widget.user.userPic,
                                      width: size,
                                      height: size,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                        width: 90,
                                        height: 90,
                                        padding: EdgeInsets.all(20),
                                      ),
                                    ),
                                  )

                                //else show defaultIcon
                                : Icon(
                                    Icons.account_circle,
                                    size: size,
                                    color: Colors.grey,
                                  )

                            //show image from file
                            : Material(
                                child: Image.file(
                                  imageFile,
                                  width: size,
                                  height: size,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(75)),
                                clipBehavior: Clip.hardEdge,
                              ),
                        Positioned(
                          left: 92,
                          top: 90,
                          child: Material(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(40),
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                splashColor: Colors.transparent,
                                iconSize: 22.0,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  width: double.infinity,
                  margin: EdgeInsets.all(30.0),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // username
                      InputField(
                        inputType: TextInputType.text,
                        controller: _userNamecontroller,
                        icon: Icon(Icons.person),
                        hintText: "Username",
                        validator: (value) {
                          if (value.isEmpty) return "Field can't be empty";
                          return null;
                        },
                      ),

                      SizedBox(height: 30),

                      // for email
                      InputField(
                        inputType: TextInputType.text,
                        controller: _aboutcontroller,
                        icon: Icon(Icons.info_outline),
                        hintText: "About",
                        validator: (value) {
                          if (value.isEmpty) return "Field can't be empty";

                          return null;
                        },
                      ),

                      SizedBox(height: 30),

                      FlatButton(
                        onPressed: () => updateUserDetails(),
                        height: 40,
                        minWidth: 200,
                        color: Colors.blue,
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(width: 3, color: Colors.blue)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  changeImage(ImageSource src) async {
    try {
      final _pickedFile = await picker.getImage(source: src);
      if (_pickedFile == null) return;

      if (src == ImageSource.camera) {
        // if camera then store
        //location provided by path provider
        final _extDir = await getExternalStorageDirectory();
        final imgPath = '${_extDir.path}/all_images'; // path location
        final imgDir = await new Directory(imgPath).create();
        File tmp = File(_pickedFile.path); // temp file from image
        print(imgDir.path); // for debug

        if (imgDir.isAbsolute) {
          tmp = await tmp.copy("$imgPath/IMG_${DateTime.now()}.jpg");
        }
      }
      setState(() {
        imageFile = File(_pickedFile.path);
      });

      EasyLoading.show(status: "Updating image...");

      ///update image and get public URl
      DataBaseMethods.uploadImagetoStorage(
              UserID: widget.user.userID, file: imageFile)
          .then((downloadURL) {
        EasyLoading.dismiss();

        //setting userPic Url
        widget.user.userPic = downloadURL;
        print("Image Url in pro.Screen: $downloadURL");
      }).catchError((e) {
        EasyLoading.showInfo("Failed updating image");
        EasyLoading.dismiss();
      });
    } catch (e) {
      print(e);
    }
  }

  ///Method to open modal and show image
  Future getImage() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          height: 72,
          color: SecondaryColour,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Stack(
                  children: [
                    IconButton(
                      alignment: Alignment.topRight,
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        changeImage(ImageSource.camera);
                        Navigator.pop(
                            context); // for dismissing the bottomsheet
                      },
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Camera",
                          style: BodyTextStyle,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Stack(
                  children: [
                    IconButton(
                        alignment: Alignment.topCenter,
                        icon: Icon(
                          Icons.folder,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          changeImage(
                            ImageSource.gallery,
                          );
                          Navigator.pop(
                              context); // for dismissing the bottomsheet
                        }),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Gallery",
                          style: BodyTextStyle,
                        ))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  updateUserDetails() {
    if (_formKey.currentState.validate()) {
      EasyLoading.show(status: "Updating profile...");

      widget.user.userName = _userNamecontroller.text;
      widget.user.userAbout = _aboutcontroller.text;

      SessionManagement.updateUserDetails(user: widget.user);
      DataBaseMethods.updateUserDetails(widget.user).then((v) {
        EasyLoading.dismiss();

        if (v) {
          print("Updated");

          EasyLoading.showSuccess("Profile updated",
              duration: Duration(seconds: 2));
        }

        Navigator.pop(context);
      });
    }
  }
}
