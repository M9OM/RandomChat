import 'package:chatme/constant/assets_constants.dart';
import 'package:chatme/constant/str_extntion.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../constant/translate_constat.dart';

class TextFiledSearch extends StatelessWidget {
  TextEditingController textController;
   TextFiledSearch({super.key, required this.textController});

  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);

    return  TextField(
                            maxLines: 4,
                            controller: textController,
                            minLines: 1,
                            style: const TextStyle(
                                 fontFamily: 'Orbitron'),
                            decoration: InputDecoration(
                              hintText: TranslationConstants.nameOfCommunity.t(context),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 93, 93, 93),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: theme.primaryColor,
                                  )),
                              hintStyle: const TextStyle(fontFamily: 'Orbitron'),
                              filled: true,
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.indigoAccent,
                                  width: 2,
                                ),
                              ),
                         
                            ),
                          );


                          
  }
}