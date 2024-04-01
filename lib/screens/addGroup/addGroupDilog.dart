import 'package:chatme/services/firebaseService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../provider/providerauth.dart';
import 'textFiled/screachTextfiled.dart';

class AddGroupDialog extends StatefulWidget {
  const AddGroupDialog({Key? key}) : super(key: key);

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  List<Map<String, dynamic>> communityIdList = [];
  List<String> docId = ['e'];
  final TextEditingController _textController = TextEditingController();

  void getDocId() async {
    final user = Provider.of<ModelsProvider>(context, listen: false);

    // Access Firestore instance
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to a collection
    CollectionReference rooms = firestore.collection('rooms');

    // Get documents from the collection
    QuerySnapshot<Object?> querySnapshot = await rooms
        .orderBy('timestamp', descending: true)
        .where('userId', arrayContainsAny: [user.usersId, user.usersId])
        .limit(20)
        .get();

    // Process each document in the collection
    for (var doc in querySnapshot.docs) {
      // Access data from each document
      // String otherUserId = doc['userId'][0] == user.usersId
      //     ? doc['userId'][1]
      //     : doc['userId'][0];

      setState(() {
        docId.addAll({
          doc['userId'][0] == user.usersId ? doc['userId'][1] : doc['userId'][0]
        });
      });

    }
            getListOfUsers = getListUserswhere(docId);

    // Print the list of docIds
    print('Document IDs: $docId');
  } 
  
  late Stream<QuerySnapshot> getListOfUsers;

  @override
  void initState() {
    super.initState();
    getDocId();
    getListOfUsers = getListUserswhere(docId);
  }
bool loading = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = Provider.of<ModelsProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: loading,
      progressIndicator:CircularProgressIndicator(),
      child: Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Column(
         crossAxisAlignment : CrossAxisAlignment.start,
    
            children: [
              const SizedBox(height: 100),
              Container(
                padding: const EdgeInsets.all(10),
                child: const Text('To: ',style: TextStyle(fontSize: 18),),),
              Container(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: communityIdList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: theme.cardColor,
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                communityIdList[index]['photoURL'].toString(),
                              ),
                            ),

                            SizedBox(height: 5,),

                            Text(communityIdList[index]['name'].toString())
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 80,
                  child:  TextFiledSearch(textController:_textController),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: getListOfUsers,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var userData = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: userData.length,
                      itemBuilder: (context, index) {
                        var user = userData[index];
                        var uid = user.id;
                        var photoURL = user['photoURL'];
                        var displayName = user['displayName'];
    
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (communityIdList.any((element) =>
                                  element['uid'] == uid)) {
                                communityIdList.removeWhere((element) =>
                                    element['uid'] == uid);
                              } else {
                                communityIdList.add({
                                  'uid': uid,
                                  'name':displayName,
                                  'photoURL': photoURL,
                                });
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: theme.cardColor),
                              ),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(photoURL),
                                backgroundColor: Colors.transparent,
                              ),
                              title: Text(displayName),
                              trailing: communityIdList.any((element) =>
                                      element['uid'] == uid)
                                  ? Container(
                                                                      width: 30,
                                    height: 30,
    
                                    padding:const EdgeInsets.all(2) ,
                                    decoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
                                    child: const Icon(Icons.done,))
                                  : Container(
                                    width: 30,
                                    height: 30,
                                    padding:const EdgeInsets.all(2) ,
                                    decoration: BoxDecoration(color: theme.primaryColor, shape: BoxShape.circle),
                                ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              InkWell(
                                  onTap: ()async {
              print(communityIdList.map((map) => map['uid'].toString()).toList());
             
        


             if(communityIdList.length>2&&_textController.text.isNotEmpty){
     setState(() {
               loading = true;
             });

  await  createGroup(user.usersId,DateTime.now().toString(),communityIdList.map((map) => map['uid'].toString()).toList(), _textController.text,context);
                    _textController.clear();
                   setState(() {
                                                   loading = false;

             });   

             }else if(communityIdList.length<2){

   final snackBar = SnackBar(
    backgroundColor: theme.cardColor,
            content: Center(child:  Text('You should add more than 2 users',style: TextStyle(color: theme.iconTheme.color),)),
            duration: const Duration(milliseconds: 1500),
            width: 280.0,
            padding:EdgeInsets.all(15),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

             } else if(_textController.text.isEmpty){

   final snackBar = SnackBar(
    backgroundColor: theme.cardColor,
            content: Center(child:  Text('You should write name for group',style: TextStyle(color: theme.iconTheme.color),)),
            duration: const Duration(milliseconds: 1500),
            width: 280.0,
            padding:EdgeInsets.all(15),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);


             }
          
    
                    },
    
    
    
                child: Container(
                  padding: const EdgeInsets.all(30),
                  color: theme.primaryColor,
                  child: Center(
                    child: Text(
                      'Add Community',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
