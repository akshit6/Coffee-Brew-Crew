import 'package:coffe_brew_crew/models/user.dart';
import 'package:coffe_brew_crew/services/database.dart';
import 'package:coffe_brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:coffe_brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  //form values
  String _currentName;
  String _currentSugars;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserOfApp>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userdata = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your brew Settings .',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: userdata.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a Name' : null,
                    onChanged: (val) {
                      setState(() {
                        _currentName = val;
                      });
                    },
                  ),
                  SizedBox(height: 20.0),
                  // dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ??
                        userdata.sugars, // value displayed on ui
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar, // value tracked for backend
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _currentSugars = val;
                      });
                    },
                  ),

                  // slider
                  Slider(
                    value: (_currentStrength ?? userdata.strength).toDouble(),
                    activeColor: Colors.brown[_currentStrength ?? 100],
                    inactiveColor: Colors.brown[_currentStrength ?? 100],
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                    min: 100.0,
                    max: 900.0,
                    divisions: 8,
                  ),

                  RaisedButton(
                    color: Colors.pink[400],
                    child: Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugars ?? userdata.sugars,
                          _currentName ?? userdata.name,
                          _currentStrength ?? userdata.strength,
                        );
                        Navigator.pop(context);
                      }
                      print(_currentName);
                      print(_currentSugars);
                      print(_currentStrength);
                    },
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
