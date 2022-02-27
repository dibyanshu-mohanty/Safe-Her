import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:safe_her/providers/help_provider.dart';

class AddContact extends StatefulWidget {
  const AddContact({Key? key}) : super(key: key);

  @override
  _AddContactState createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  final _nameController = TextEditingController();
  String _phone = "";
  final _formKey = GlobalKey<FormState>();

  void addContact(String name, String number){
    Provider.of<ContactProvider>(context,listen: false).addContact(name, number);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 4,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Add New Savior",
              style: TextStyle(fontSize: 20.0),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                              BorderSide(width: 1.0, color: Colors.purple)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                              BorderSide(width: 1.0, color: Colors.red)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                              BorderSide(width: 2.0, color: Colors.grey)),
                          labelText: "Name of the Savior"),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please add a Name";
                        }
                      },
                      controller: _nameController,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    child: InternationalPhoneNumberInput(
                      onInputChanged: (value) {
                        setState(() {
                          _phone = value.phoneNumber!;
                        });
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Please fill this field";
                        } else if (value.length < 11){
                          return "Invalid Number";
                        }
                      },
                      maxLength: 11,
                      inputDecoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                              BorderSide(width: 1.0, color: Colors.purple)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                              BorderSide(width: 1.0, color: Colors.red)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide:
                              BorderSide(width: 2.0, color: Colors.grey)),
                          labelText: "Enter Phone No."),
                      spaceBetweenSelectorAndTextField: 4.0,
                      selectorConfig: SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        showFlags: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                if(_formKey.currentState!.validate()){
                  addContact(_nameController.text, _phone);
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.add),
              label: Text("Add Savior"),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(14.0)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0))),
              ),
            )
          ],
        ),
      ),
    );
  }
}
