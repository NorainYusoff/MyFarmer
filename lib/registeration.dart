import 'dart:convert';
import 'package:flutter/material.dart';
import 'loginscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String pathAsset = 'assets/images/profile.png';
String urlUpload = "http://lastyeartit.com//myfarmer_admin/registration.php";

final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emailcontroller = TextEditingController();
final TextEditingController _pwcontroller = TextEditingController();
final TextEditingController _phonecontroller = TextEditingController();
String _name, _email, _password, _phone;
File _image;

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
  const RegisterScreen ({Key key, File image}) : super(key: key);
}

class _RegisterUserState extends State<RegisterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('New User Registeration'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
            child: RegisterWidget(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressAppBar() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
    return Future.value(false);
  }
}

class RegisterWidget extends StatefulWidget {
  @override
  RegisterWidgetState createState() => RegisterWidgetState();
}

class RegisterWidgetState extends State<RegisterWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: _choose,
            child: Container(
              width: 180,
              height: 200,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: _image == null
                        ? AssetImage(pathAsset)
                        : FileImage(_image),
                    fit: BoxFit.fill,
                  )),
            )),
        Text('Click on image above to take profile picture'),
        TextField(
            controller: _emailcontroller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              icon: Icon(Icons.email),
            )),
        TextField(
            controller: _namecontroller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Name',
              icon: Icon(Icons.person),
            )),
        TextField(
          controller: _pwcontroller,
          decoration:
              InputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
          obscureText: true,
        ),
        TextField(
            controller: _phonecontroller,
            keyboardType: TextInputType.phone,
            decoration:
                InputDecoration(labelText: 'Phone', icon: Icon(Icons.phone))),
        SizedBox(
          height: 10,
        ),
        RaisedButton(
          child: Text('Register'),
          onPressed: _onRegister,
        ),
        SizedBox(
          height: 10,
        ),
        GestureDetector(
                onTap: _onBackPress,
                child: Text('Allready Register',
                    style: TextStyle(fontSize: 16))),
      ],
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
    //_image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  void _onRegister() {
    print('onRegister Button from RegisterUser()');
    print(_image.toString());
    uploadData();
    }

  void _onBackPress() {
    _image = null;
    print('onBackpress from RegisterUser');
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
  }
  
  void uploadData() {
    _name = _namecontroller.text;
    _email = _emailcontroller.text;
    _password = _pwcontroller.text;
    _phone = _phonecontroller.text;

    if ((_isEmailValid(_email)) &&
        (_password.length > 4) &&
        (_image != null) &&
        (_phone.length > 5)) {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Registration in progress");
      pr.show();

      String base64Image = base64Encode(_image.readAsBytesSync());
      http.post(urlUpload, body: {
        "encoded_string": base64Image,
        "name": _name,
        "email": _email,
        "password": _password,
        "phone": _phone,
      }).then((res) {
        print(res.statusCode);
        Toast.show(res.body, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _image = null;
        _namecontroller.text = '';
        _emailcontroller.text = '';
        _phonecontroller.text = '';
        _pwcontroller.text = '';
        pr.dismiss();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
      }).catchError((err) {
        print(err);
      });
    } else {
      Toast.show("Check your registration information", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

   bool _isEmailValid(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void savepref(String email, String pass) async {
    print('Inside savepref');
    _email = _emailcontroller.text;
    _password = _pwcontroller.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //true save pref
    await prefs.setString('email', email);
    await prefs.setString('pass', pass);
    print('Save pref $_email');
    print('Save pref $_password');
  }
}

 
