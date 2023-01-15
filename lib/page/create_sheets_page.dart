import 'package:flutter/material.dart';
import 'package:google_sheets_api/api/sheets/user_sheets_api.dart';
import 'package:google_sheets_api/model/user.dart';

import '../widget/button_widget.dart';
import '../widget/user_form_widget.dart';

class CreateSheetsPage extends StatelessWidget {
  const CreateSheetsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Sheets'),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: UserFormWidget(
            onSavedUser: (user) async {
              final id = await UserSheetsApi.getRowCount() + 1;
              final newUser = user.copy(id: id);

              await UserSheetsApi.insert([newUser.toJson()]);
            },
            // onClicked: () async {
            // insertUsers();
            // final user = User(
            //   id: 1,
            //   name: 'Paul',
            //   email: 'paul@gmail.com',
            //   isBeginner: true,
            // );

            /*{
        
        
                UserFields.id: 1,
                UserFields.name: 'Paul',
                UserFields.email: 'ppaul@gmail.com',
                UserFields.isBeginner: true,
             
              };
              await UserSheetsApi.insert([user.toJson()]);*/
            // },
            // text: 'Save',
          ),
        ),
      ),
    );
  }

  Future insertUsers() async {
    final users = [
      User(id: 1, name: 'John', email: 'john@gmail.com', isBeginner: true),
      User(id: 2, name: 'Emma', email: 'emma@gmail.com', isBeginner: true),
      User(id: 3, name: 'Paul', email: 'paul@gmail.com', isBeginner: true),
      User(id: 4, name: 'Dean', email: 'dean@gmail.com', isBeginner: true),
      User(id: 5, name: 'Lisa', email: 'lisa@gmail.com', isBeginner: true),
    ];
    final jsonUsers = users.map((user) => user.toJson()).toList();

    await UserSheetsApi.insert(jsonUsers);
  }
}
