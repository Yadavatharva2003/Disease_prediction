import 'package:disease_prediction/users.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:disease_prediction/Home.dart';
import 'package:disease_prediction/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '1064371768312-lftsf6105thf1jmrn42pm5tgvds1m1q6.apps.googleusercontent.com',
  );

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health App - Login'),
        backgroundColor: Colors.red[200],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  icon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[200],
                ),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: _signUp,
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: TextStyle(color: Colors.red[200]),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: Icon(
                  Icons.add,
                  size: 30,
                ),
                label: Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[200],
                ),
              ),
              // Add a button for "Forgot Password"
              TextButton(
                onPressed: _forgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.red[200]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Check if authentication is successful
        if (userCredential.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication failed')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  void _signUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }
  void _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        // Sign in to Firebase using the Google credentials
        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        // Check if the user already exists
        final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        // Check if authentication is successful
        if (userCredential.user != null) {
          if (isNewUser) {
            // If the user is new, navigate to the Users page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Users()),
            );
          } else {
            // If the user already exists, navigate to the Home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication failed')),
          );
        }
      }
    } catch (error) {
      print('Error signing in with Google: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in with Google: $error')),
      );
    }
  }


  // Function to handle forgot password
  void _forgotPassword() async {
    if (_emailController.text.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: _emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent')),
        );
      } catch (error) {
        print('Error sending password reset email: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your email')),
      );
    }
  }
}
