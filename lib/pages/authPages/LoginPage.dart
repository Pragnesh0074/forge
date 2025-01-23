import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Forge/pages/HomePage.dart';
import 'package:Forge/pages/authPages/SignupPage.dart';
import 'package:Forge/utils/AuthService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Size size;
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/fire.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: size.height * 0.02),
              const Text(
                'FORGE',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 36,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                width: size.width * 0.8,
                child: TextField(
                  controller: email_controller,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                width: size.width * 0.8,
                child: TextField(
                  controller: password_controller,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.password),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                  width: size.width * 0.8,
                  child: InkWell(
                    onTap: () async {
                      UserCredential? result = await auth.signIn(
                          email_controller.text, password_controller.text);
                      if (result != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Login Successful"),
                        ));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Login Failed"),
                        ));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.lightGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  )),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      // Add your code here
                    },
                    child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupPage()));
                        },
                        child: Text('Register')),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
