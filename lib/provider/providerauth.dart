import 'package:flutter/cupertino.dart';


class ModelsProvider with ChangeNotifier {
  String roomID = "";
  String ontherID = "";
  String usersId ="";
  List topicSeclected = [];



void topicSeclect (List topic){
  topicSeclected.addAll(topicSeclected);
  notifyListeners();
}

  void setCurrentModel(String usersIds) {

    usersId = usersIds;
    notifyListeners();
  }




}