import 'package:book/config.dart';
import 'package:book/extension.dart';
import 'package:book/models/users.dart';
import 'package:book/pages/mainmenu.dart';
import 'package:flutter/material.dart';
import 'package:splash_view/splash_view.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:email_validator/email_validator.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/login';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashView(
      backgroundColor: '#E72913'.toColor(),
      loadingIndicator: SizedBox(
        width: 50,
        height: 50,
        child: LoadingIndicator(
            indicatorType: Indicator.ballPulse,
            colors: const [Colors.white],
            strokeWidth: 2,
            backgroundColor: '#E72913'.toColor(),
            pathBackgroundColor: Colors.black),
      ),
      logo: Image.asset(
        'assets/images/BookDD.png',
        height: 300,
        width: 300,
      ),
      done: Done(
        const Login(),
      ),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final Users _user = Users();
  Future<void> login(Users user) async {
    var params = {"email": user.email, "password": user.pssword};

    var url = Uri.http(Config.server, "users", params);
    var res = await http.get(url);
    print(res.body);

    List<Users> login_result = usersFromJson(res.body);
    if (login_result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('email or password invalid')));
    } else {
      Config.login = login_result[0];
      Navigator.pushNamed(context, MainMenu.routeName);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height * 1,
          color: '#E72913'.toColor(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.50,
                  child: SizedBox(
                    child: Image.asset(
                      'assets/images/BookDD.png',
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: 300,
                    height: MediaQuery.of(context).size.height * 0.40,
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text('Login',
                              style: GoogleFonts.kanit(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30))),
                          const SizedBox(
                            height: 10,
                          ),
                          email(),
                          const SizedBox(
                            height: 15,
                          ),
                          password(),
                          const SizedBox(
                            height: 20,
                          ),
                          loginButton(context)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget email() {
    return TextFormField(
      onSaved: (newValue) => _user.email = newValue,
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'Your email',
        hintStyle: GoogleFonts.kanit(),
        labelStyle: GoogleFonts.kanit(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: '#E72913'.toColor(), width: 1.5)),
        prefixIcon: Icon(
          Icons.person,
          color: '#E72913'.toColor(),
          size: 30,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณาใส่ Email';
        }
        if (!EmailValidator.validate(value)) {
          return 'This not email format';
        }
        return null;
      },
    );
  }

  Widget password() {
    return TextFormField(
      onSaved: (newValue) => _user.pssword = newValue,
      style: GoogleFonts.kanit(textStyle: const TextStyle(fontSize: 15)),
      // obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Your Password',
        labelStyle: GoogleFonts.kanit(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: '#E72913'.toColor(), width: 1.5)),
        prefixIcon: Icon(
          Icons.lock,
          color: '#E72913'.toColor(),
          size: 30,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'กรุณาใส่ Password';
        }
        return null;
      },
    );
  }

  Widget loginButton(context) {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            login(_user);
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          backgroundColor: '#E72913'.toColor(),
          shape: const StadiumBorder(),
        ),
        child: Text('LOGIN',
            style: GoogleFonts.kanit(
                textStyle: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20))));
  }
}
