import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget{
  const AuthScreen ({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }

}
class _AuthScreenState extends State<AuthScreen>{
  final _form = GlobalKey<FormState>();
  var _islogin =true;
  var _enteredemail ='';
  var _enteredpass = '';


  void _submit (){
    final _isvalid =_form.currentState!.validate();
    if(_isvalid){
      _form.currentState!.save();
      print(_enteredemail);
      print(_enteredpass );

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
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _form,
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email Address"
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value){
                                if(value==null|| value.trim().isEmpty|| !value.contains('@')){
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              onSaved: (value){
                                _enteredemail = value!;

                              },
                            ),
                            TextFormField(
                              decoration:const InputDecoration(
                                  labelText: "Password"
                              ),
                              obscureText: true ,
                              validator: (value){
                                if(
                                value==null ||
                                    value.trim().length<6)
                                {
                                  return 'Password must be at least 6 characters long.';
                                }
                                return null;
                              },
                              onSaved: (value){
                                _enteredpass = value!;

                              },
                            ),
                            const SizedBox(height: 14,),
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(_islogin ? 'Login ' : 'Signup'),
                            ),
                            TextButton(
                              onPressed: (){
                                setState(() {
                                  _islogin = !_islogin;
                                });
                                },
                              child: Text(_islogin ?'Create an account':'You already have an account.'),
                            ),
                          ],
                        ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}