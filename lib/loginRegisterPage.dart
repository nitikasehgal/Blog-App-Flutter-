import 'package:blog_app/dialogbox.dart';
import 'package:blog_app/firebasefunction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  DialogBox dialogBox = DialogBox();
  final key = GlobalKey<FormState>();

  signup(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      print("success");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return dialogBox.information(context, "Error =", e.code);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return dialogBox.information(context, "Error =", e.code);
      }
    } catch (e) {
      return dialogBox.information(context, "Error =", e.toString());
    }
  }

  signin(String email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print('/////// Success ////////');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return dialogBox.information(context, "Error =", e.code);
      } else if (e.code == 'wrong-password') {
        return dialogBox.information(context, "Error =", e.code);
      }
    }
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  getcurrentuser() async {
    User user = await FirebaseAuth.instance.currentUser!;
    return user.uid;
  }

  String email = '';
  String password = '';
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Blog App"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(15),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Hero(
                    tag: "hero",
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Image.network(
                        'https://www.hudsonintegrated.com/pub/blogimages/20140305094710_blog49006_640.png',
                        fit: BoxFit.cover,
                      ),
                      radius: 110,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email is required";
                      }
                      if (!value.contains('@')) {
                        return "Email can't be without @";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      setState(() {
                        email = value!;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Enter your email",
                        label: Text("Email"),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    key: ValueKey('password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password can't be empty";
                      } else if (value.length <= 6) {
                        return "Password can't be less than 8 characters";
                      } else {
                        return null;
                      }
                    },
                    obscureText: true,
                    onSaved: (value) {
                      setState(() {
                        password = value!;
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Enter your Password",
                        label: Text("Password"),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 2))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (key.currentState!.validate()) {
                          key.currentState!.save();
                          isLogin
                              ? signin(email, password)
                              : signup(email, password);
                        }
                      },
                      child: isLogin ? Text('Login') : Text('Signup')),
                  SizedBox(
                    height: 8,
                  ),
                  TextButton(
                      onPressed: () async {
                        setState(() {
                          isLogin = !isLogin;
                        });
                      },
                      child: !isLogin
                          ? Text(
                              "Already have an account? Log IN!",
                              style: TextStyle(fontSize: 14.0),
                            )
                          : Text("Don't have an account?Sign Up"))
                ],
              ),
            )),
      ),
    );
  }
}
