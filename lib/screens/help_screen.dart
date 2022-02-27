import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:safe_her/providers/help_provider.dart';
import 'package:safe_her/utils/add_help.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              "assets/images/people_screen_bg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(onPressed: (){
                    Navigator.pop(context);
                  },
                    icon: Icon(Icons.arrow_back_ios,color: Colors.white,),
                  ),
                ),
                Text(
                  "Saviors",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0,color: Colors.white),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14.0, vertical: 4.0),
                  child: Text(
                    "Add the contacts of your Close Ones !",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.w400, fontSize: 16.0,color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: FutureBuilder(
                      future:
                          Provider.of<ContactProvider>(context, listen: false)
                              .fetchAndSetContacts(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Consumer<ContactProvider>(
                          child: Center(
                            child: Image.asset(
                                "assets/images/no_users_added.png"),
                          ),
                          builder: (context, contacts, ch) {
                            if (contacts.items.isEmpty) {
                              return ch!;
                            } else {
                              return ListView.builder(
                                  itemCount: contacts.items.length,
                                  itemBuilder: (context, index) => Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        child: Card(
                                          elevation: 6,
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              backgroundImage: AssetImage(
                                                  "assets/images/user_icon.png"),
                                            ),
                                            title: Text(
                                              contacts.items[index].name,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            subtitle:
                                                Text(contacts.items[index].mob),
                                            trailing: SizedBox(
                                              width: 80,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  InkWell(
                                                      child: Icon(
                                                    Icons.edit_outlined,
                                                    color: Color(0xFF24A4D6),
                                                  )),
                                                  InkWell(
                                                      onTap: () {
                                                        Provider.of<ContactProvider>(
                                                                context,
                                                                listen: false)
                                                            .deleteContact(
                                                                contacts
                                                                    .items[
                                                                        index]
                                                                    .id);
                                                      },
                                                      child: Icon(
                                                        Icons.delete_outlined,
                                                        color: Colors.red,
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ));
                            }
                          },
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddContact(),
          );
        },
        child:FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
