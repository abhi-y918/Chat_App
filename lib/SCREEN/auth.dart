import 'dart:io';

import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPass = '';
  File? selectedimage;


  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || (!_isLogin && selectedimage == null)) return;

    _form.currentState!.save();

    try {
      if (_isLogin) {
        await supabase.auth.signInWithPassword(
          email: _enteredEmail,
          password: _enteredPass,
        );
        return;
      }

      // SIGN UP
      final res = await supabase.auth.signUp(
        email: _enteredEmail,
        password: _enteredPass,
      );

      final userId = res.user?.id;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sign-up complete.'),
          ),
        );
        return;
      }

      // READ FILE BYTES
      final fileBytes = await selectedimage!.readAsBytes();
      final path = '$userId/avatar.jpg'; // must start with uid per your policies

      // uploading to Chat_app bucket in supabase
      await supabase.storage
          .from('Chat_app')
          .uploadBinary(
        path,
        fileBytes,
        fileOptions: const FileOptions(
          contentType: 'image/jpeg',
          upsert: true,
        ),
      );

      final signedUrl = await supabase.storage
          .from('Chat_app')
          .createSignedUrl(path, 3600);

      print(' Uploaded image URL: $signedUrl',
      );
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    } catch (error, st) {
      debugPrintStack(label: 'Unexpected error: $error', stackTrace: st);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: 200,
                child: Image.asset('assets/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_isLogin)
                          UserImagepicker(
                            onPickedimage: (pickedImage) {
                              selectedimage = pickedImage;
                            },
                          ),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Email Address",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(labelText: "Password"),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.trim().length < 6) {
                              return 'Password must be at least 6 characters long.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredPass = value!;
                          },
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: Text(_isLogin ? 'Login' : 'Signup'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(_isLogin
                              ? 'Create an account'
                              : 'You already have an account.'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


