import 'package:flutter/cupertino.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';


class ModelsProvider with ChangeNotifier {
  String roomID = "";
  String ontherID = "";
  String usersId ="";
  List topicSeclected = [];
bool isBoottomHide =false;

void hideBootom(bool isShow){
isBoottomHide = isShow;
notifyListeners();
}
void topicSeclect (List topic){
  topicSeclected.addAll(topicSeclected);
  notifyListeners();
}

  void setCurrentModel(String usersIds) {

    usersId = usersIds;
    notifyListeners();
  }




}