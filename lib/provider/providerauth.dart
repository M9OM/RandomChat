import 'package:flutter/cupertino.dart';


class ModelsProvider with ChangeNotifier {
  // String currentModel = "text-davinci-003";
  String roomID = "";
  String ontherID = "";
String usersId ="";


  void setCurrentModel(String usersIds) {
    usersId = usersIds;
    notifyListeners();
  }




}