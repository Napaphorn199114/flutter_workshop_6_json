import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import 'package:workshop_6_json/models/User.dart';
import 'package:workshop_6_json/services/AuthService.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>(); //สร้าง formkey
  User user = User();
  AuthService authService = AuthService();

  FocusNode passwordFocusNode = FocusNode();   //กรอก email เสร็จ สามารถกรอก password ได้เลย

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      // ใช้ stack เพราะต้องการวางหลายชั้น ชั้นแรกเป็น bg image
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        ListView(
          children: [
            _buildForm(),
          ],
        ),
      ],
    ));
  }

  Widget _buildForm() => Card(
        margin: EdgeInsets.only(top: 80, left: 30, right: 30),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, //สร้าง formkey ผูกกับ form
            child: Column(
              children: [
                _logo(),
                SizedBox(
                  height: 22,
                ),
                _buildUsernameInput(),
                SizedBox(
                  height: 8,
                ),
                _buildPasswordInput(),
                SizedBox(
                  height: 28,
                ),
                _buildSubmitButton(),
                _buildForgotPasswordButton(),
              ],
            ),
          ),
        ),
      );

  Widget _logo() => Image.asset(
        ("assets/header_main.png"),
        fit: BoxFit.cover,
      );

  Widget _buildUsernameInput() => TextFormField(
        decoration: InputDecoration(
          labelText: 'Email',
          hintText: 'example@gmail.com',
          icon: Icon(Icons.email),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: _validateEmail,
        onSaved: (String? value) {
          user.Username = value!;
        },
        onFieldSubmitted: (String value) {
          FocusScope.of(context).requestFocus(passwordFocusNode);  //กรอก email เสร็จ สามารถกรอก password ได้เลย
        },
      );

  Widget _buildPasswordInput() => TextFormField(
        focusNode: passwordFocusNode,    //กรอก email เสร็จ สามารถกรอก password ได้เลย
        decoration: InputDecoration(
          labelText: 'Password',
          icon: Icon(Icons.lock),
        ),
        obscureText: true,
        validator: _validatePassword,
        onSaved: (String? value) {
          user.Password = value!;
        },

        // onFieldSubmitted: (String value) {},
      );

  Widget _buildSubmitButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: _submit,
          child: Text("Login".toUpperCase()), // set ตัวใหญ๋
        ),
      );

  void _submit() {
    if (this._formKey.currentState!.validate()) {
      _formKey.currentState?.save();

      authService.login(user: user).then((result) {
        if (result) {
          Navigator.pushReplacementNamed(context, '/home');

        } else {
          _showAlertDialog();
        }
      });
    }
  }

  void _showAlertDialog() {
    showDialog(
        context: context,
        barrierDismissible: false, // ถ้ามี alert มา จะไม่สามารถกดพื้นที่ข้างนอกได้นอกจากปุ่ม OK
        builder: (context) {
          return AlertDialog(
            title: Text("Username or Password is incorrect."),
            content: Text("Please Try Again "),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);  // pop ทำการปิด
                },
                child: Text("OK"),
              ),
            ],
          );
        });
  }

  Widget _buildForgotPasswordButton() => Container(
        width: MediaQuery.of(context).size.width,
        child: TextButton(
            onPressed: () {},
            child: Text(
              "Forgot password?",
              style: TextStyle(color: Colors.black54),
            )),
      );

  String? _validateEmail(String? value) {
    //if (value == null || value.isEmpty) {
    if (value!.isEmpty) {
      return 'The Email is Empty.';
    }
    if (!isEmail(value)) {
      return "The Email must be a valid email.";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.length < 8) {
      return "The Password must be at least 8 charactors.";
    }
    return null;
  }
}
