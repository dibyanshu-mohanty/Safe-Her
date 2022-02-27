import 'package:flutter/cupertino.dart';
import 'package:safe_her/providers/db_provider.dart';

class Contact {
  final String id;
  final String name;
  final String mob;

  Contact({required this.id, required this.name, required this.mob});
}

class ContactProvider with ChangeNotifier {
  List<Contact> _items = [];
  List<Contact> get items {
    return [..._items];
  }
  List<String> _numbers = [];

  void addContact(String name, String number) {
    final newContact =
    Contact(id: DateTime.now().toString(), name: name, mob: number);
    _items.add(newContact);
    notifyListeners();
    DBHelper.insert("contacts", {
      "id": newContact.id,
      "name": newContact.name,
      "number": newContact.mob,
    });
  }

  Future<void> fetchAndSetContacts() async {
    final data = await DBHelper.getData("contacts");
    _items = data
        .map((e) => Contact(name: e['name'], mob: e['number'], id: e['id']))
        .toList();
    notifyListeners();
  }

  void deleteContact(String id){
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    DBHelper.delete("contacts", id);
  }

  Future<List<String>> getNumbers() async{
    final data = await DBHelper.getData("contacts");
    _numbers = data.map((e) => e['number'].toString()).toList();
    notifyListeners();
    return _numbers;
  }
}
