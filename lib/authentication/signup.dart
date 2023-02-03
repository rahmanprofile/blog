import 'package:blog/authentication/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showSpinner = false;
  String email = "", password = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child:  Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("SignUp",style: GoogleFonts.lato(
                    fontWeight: FontWeight.w600,fontSize: 35,color: Colors.black54),
                ),
                const SizedBox(height:20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300]
                    ),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value){
                        return value!.isEmpty? "Enter email" : null;
                      },
                      onChanged: (String val){
                        email = val;
                      },
                      style: GoogleFonts.lato(fontSize: 16,fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon:const Icon(Icons.person),
                          hintStyle: GoogleFonts.lato(fontSize: 16,fontWeight: FontWeight.w600),
                          border:const OutlineInputBorder(borderSide: BorderSide.none)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300]
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      validator: (value) {
                        return value!.isEmpty ? "Enter password" : null;
                      },
                      onChanged: (String val){
                        password = val;
                      },
                      style: GoogleFonts.lato(fontSize: 16,fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon:const Icon(Icons.key),
                          hintStyle: GoogleFonts.lato(fontSize: 16,fontWeight: FontWeight.w600),
                          border:const OutlineInputBorder(borderSide: BorderSide.none)
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: GestureDetector(
                    onTap: () async {
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final user = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: email.toString().trim(),
                            password: password.toString().trim(),
                          );
                          if (user != null){
                            showToast("User successfully signup");
                            setState(() {
                              showSpinner = false;
                            });
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> const Home())
                            );
                          }

                        } catch (e){
                          print(e.toString());
                          showToast(e.toString());
                        }
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
                        child: Text("SignUp",
                          style: GoogleFonts.lato(fontWeight: FontWeight.w600,fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?",
                      style: GoogleFonts.lato(fontWeight: FontWeight.w600,fontSize: 16),),
                    TextButton(
                      onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SignIn()));
                      },
                      child: Text("SignIn",
                        style: GoogleFonts.lato(fontWeight: FontWeight.w600,fontSize: 16,
                            color: Colors.purple),
                      ),
                    ),
                  ],
                )
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
