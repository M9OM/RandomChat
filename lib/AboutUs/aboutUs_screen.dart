import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
                    final theme = Theme.of(context);

    return  Scaffold(
      body: Column(
          children: [

     Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: theme.appBarTheme.backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back_ios_new_sharp),
                ),
    ])]))),

            Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Text(
                    "Welcome to our app!\n\n"
                    "At [App Name], we believe in the power of connections. Our platform is designed to bring people together from all walks of life, allowing them to engage in meaningful conversations with random individuals across the globe.\n\n"
                    "Behind the scenes, this app is the brainchild of Mohammed Said Al Busafi, a passionate developer dedicated to creating innovative solutions that foster genuine human connections in the digital age.\n\n"
                    "Whether you're seeking new friendships, interesting conversations, or simply a moment of connection in an increasingly interconnected world, [App Name] provides a platform for you to explore and engage with others in a safe and respectful environment.\n\n"
                    "With features tailored to enhance your chatting experience, such as [mention any unique features], our app strives to make every interaction memorable and enjoyable.\n\n"
                    "Join us on this journey of discovery, as we connect people one chat at a time.\n\n"
                    "Thank you for being a part of the [App Name] community!",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      
    );
  }
}
