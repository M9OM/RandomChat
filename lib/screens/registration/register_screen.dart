import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../constant/assets_constants.dart';
import '../../services/google_auth.dart';
import '../../widgets/bouttonWithIcon copy.dart';
class register_screen extends StatefulWidget {
  const register_screen({super.key});

  @override
  State<register_screen> createState() => _register_screenState();
}



String username = "";
String email = "";
String password = "";
bool loging = false;

class _register_screenState extends State<register_screen> {
  @override
  Widget build(BuildContext context) {
        final theme = Theme.of(context);

    return ModalProgressHUD(
      inAsyncCall: loging,
      progressIndicator:const CircularProgressIndicator(),
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'CREATE YOUR ACCOUNT',
                  style: TextStyle(
                      fontSize: 40.0, fontWeight: FontWeight.bold),

                ),
         
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: boutton_Icon(
                      hintText: 'S I G N   I N   W I T H   G O O G L E',
                      iconPath: AssetsConstants.googleIcon,
                      onTap: () async {
                        setState(() {
                          loging = true;
                        });

                        try {
                          await AuthServices.signInWithGoogle(context);
                        } catch (error) {
                          // Handle the cancellation or any error that occurred during sign-in
                          print(
                              'Sign-in with Google canceled or encountered an error: $error');
                        }

                        setState(() {
                          loging = false;
                        });
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14),
                        children: <TextSpan>[
                           TextSpan(
                              text: 'By clicking, you are accepting the ',style: TextStyle(color: theme.iconTheme.color)),
                          TextSpan(
                              text: 'Terms of Use',
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // ignore: deprecated_member_use
                                  launch(
                                      'https://github.com/moha332/Terms-of-Use/blob/main/Terms-of-Use.md');
                                }),
                           TextSpan(
                            text: ' and ',
                            style: TextStyle(color: theme.iconTheme.color),
                          ),
                          TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                  color: Colors.blue, fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // ignore: deprecated_member_use
                                  launch(
                                      'https://github.com/moha332/chat-qalam/blob/main/privacy-policy.md');
                                }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
