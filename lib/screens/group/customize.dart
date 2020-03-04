import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:rsldb/components/extended_button.dart';
import 'package:rsldb/components/group_icon.dart';
import 'package:rsldb/components/input_text_field.dart';
import 'package:rsldb/helpers/flushbar.dart';
import 'package:rsldb/helpers/validators.dart';
import 'package:rsldb/main.dart';
import 'package:rsldb/models/group.dart';
import 'package:rsldb/routes/app_state.dart';
import 'package:rsldb/services/group.dart';

class CustomizeGroup extends StatefulWidget {
  @override
  _CustomizeGroupState createState() => _CustomizeGroupState();
}

class _CustomizeGroupState extends State<CustomizeGroup> {
  final _formKey = GlobalKey<FormState>();
  final application = sl.get<AppState>();

  String _currentName;
  String _currentInitials;
  int _currentColor;

  @override
  Widget build(BuildContext context) {
    Color initialColor = application.currentGroup.color == null
        ? Color(0xff443a49)
        : Color(application.currentGroup.color);

    void changeColor(Color color) {
      setState(() {
        return _currentColor = color.value;
      });
    }

    void updateGroupSettings() async {
      if (_formKey.currentState.validate()) {
        try {
          await GroupService().updateGroupSettings(
            application.currentGroup.copyWith(
              Group(
                name: _currentName,
                initials: _currentInitials,
                color: _currentColor,
              ),
            ),
          );
          FlushbarHelper(context, Status.success, 'Group customizations saved.').show();
        } catch (e) {
          FlushbarHelper(context, Status.error, e.toString()).show();
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Update group settings'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0),
              // GroupIcon
              Row(
                children: <Widget>[
                  GroupIcon(
                    application.currentGroup.copyWith(
                      Group(
                        name: _currentName,
                        initials: _currentInitials,
                        color: _currentColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0),
                  GroupIcon(
                    application.currentGroup.copyWith(
                      Group(
                        name: _currentName,
                        initials: _currentInitials,
                        color: _currentColor,
                      ),
                    ),
                    size: Size.small,
                  ),
                  SizedBox(width: 20.0),
                  InkWell(
                    onTap: () => showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text('Pick a color!'),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: initialColor,
                            onColorChanged: changeColor,
                            enableLabel: false,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              setState(() => _currentColor = application.currentGroup.color);
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Got it'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      width: 130.0,
                      height: 40.0,
                      alignment: FractionalOffset.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).buttonColor,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      child: Text('Change Color', style: TextStyle(fontSize: 16.0)),
                    ),
                  ),
                ],
              ),
              // AlertDialog
              SizedBox(height: 30.0),
              InputTextField(
                icon: Icons.group,
                initialValue: application.currentGroup.name,
                labelText: 'Group Name',
                onChanged: (value) => setState(() => _currentName = value),
                validator: (value) => Validators.validateString(value, 'group name'),
              ),
              SizedBox(height: 10.0),
              InputTextField(
                icon: Icons.group_work,
                initialValue: application.currentGroup.initials,
                labelText: 'Icon Initials',
//                maxLength: 3,
                onChanged: (value) => setState(() => _currentInitials = value),
              ),
              SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(25),
        child: ExtendedButton(
          text: 'Update',
          onTap: updateGroupSettings,
        ),
      ),
    );
  }
}
