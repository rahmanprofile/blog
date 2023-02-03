import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Post extends StatefulWidget {
  const Post({Key? key}) : super(key: key);

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  bool showSpinner = false;
  final postRef = FirebaseDatabase.instance.ref().child("Post");
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
  String titleContain = '';
  String descriptionContain = '';
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  File? _image;
  Future getGalImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print("No! image selected from gallery");
      }
    });
  }
  Future getCamImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print("No! image selected from camera");
      }
    });
  }
  void postDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      getCamImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      title: Text("Camera"),
                      leading: Icon(Icons.camera_alt),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      getGalImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      title: Text("Gallery"),
                      leading: Icon(Icons.image_outlined),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title:const Text("Create Post"),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                  child: InkWell(
                    onTap: (){
                      postDialog(context);
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200],
                      ),
                      child: _image != null ? ClipRRect(
                        child: Image.file(
                            _image!.absolute,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ) : Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:const Icon(Icons.camera_alt,color: Colors.blue,),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: title,
                    maxLines: 1,
                    onChanged: (String value){
                      titleContain = value;
                    },
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: "Title of the post",
                      label:const Text("Title"),
                      border:const OutlineInputBorder(),
                      hintStyle: GoogleFonts.lato(fontSize: 20,fontWeight: FontWeight.w600)
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    controller: description,
                    maxLines: 10,
                    onChanged: (String value){
                      descriptionContain = value;
                    },
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                        hintText: "Description of the post",
                        label:const Text("Description"),
                        border:const OutlineInputBorder(),
                        hintStyle: GoogleFonts.lato(fontSize: 18,fontWeight: FontWeight.w600)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                  child: InkWell(
                    onTap: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        int date = DateTime.now().microsecondsSinceEpoch;
                        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref("/blog");
                        UploadTask uploadTask = ref.putFile(_image!.absolute);
                        await Future.value(uploadTask);
                        var newUrl = await ref.getDownloadURL();
                        final User? user = FirebaseAuth.instance.currentUser;
                        postRef.child("Post List").child(date.toString()).set({
                          'Id':date.toString(),
                          'Image':newUrl.toString(),
                          'Title':title.text.toString(),
                          'Description':description.text.toString(),
                          'Email':user!.email.toString(),
                          'Uid':user.uid.toString(),
                        }).then((value){
                          showToast("Post successfully published.");
                          setState(() {
                            showSpinner = false;
                          });
                        }).onError((error, stackTrace) {
                          showToast(error.toString());
                          setState(() {
                            showSpinner = false;
                          });
                        });
                      } catch (e){
                        setState(() {
                          showSpinner = false;
                        });
                        showToast(e.toString());
                      }
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.purple
                      ),
                      child: Center(
                        child: Text("Post",
                          style: GoogleFonts.lato(fontWeight: FontWeight.w600,fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 0,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0
    );
  }

}
