import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3_exams_193222/screens/home_screen.dart';
import 'package:lab3_exams_193222/screens/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String id = "signinScreen";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  bool passwordError = false;
  bool emailError = false;
  String loginErrorMessage = "test";
  bool loginFail = false;


  Future _signIn() async{
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailTextController.text,
          password: _passwordTextController.text)
          .then((value) {
        print("User signed in successfully!");
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } on FirebaseAuthException catch (e){
      print("ERROR");
      print(e.message);
      loginFail = true;
      loginErrorMessage = e.message!;

      if(loginErrorMessage == "There is no user record corresponding to this identifier. The user may have been deleted."){
        emailError = true;
        loginErrorMessage = "User does not exist, please create new account";
      }else {
        passwordError = true;
        loginErrorMessage = "Password is incorrect";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height*0.1, 20, 0),
                child: Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text("Welcome", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 30),),
                      SizedBox(height: 40),
                      TextField(
                        controller: _emailTextController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                            labelText: "Email",
                            errorText: emailError ? loginErrorMessage : null
                        ),
                      ),
                      SizedBox(height: 40),
                      TextField(
                        controller: _passwordTextController,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            labelText: "Password",
                            errorText: passwordError ? loginErrorMessage : null
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(50)),
                        icon: Icon(Icons.lock_open_sharp, size: 30,),
                        label: Text("Sign In", style: TextStyle(fontSize: 22),),
                        onPressed: _signIn,
                      ),
                      SizedBox(height: 20),
                      signUpOption()
                    ]
                )
            )
        )
    );
  }

  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Create new Account:"),
        GestureDetector(
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()));
            },
            child: const Text(" Sign Up",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
        ),
      ],
    );
  }



}
