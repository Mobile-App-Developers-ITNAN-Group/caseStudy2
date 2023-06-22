import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Firebase.initializeApp()
  await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  runApp(const MyApp());
}

final TextEditingController _usernameController = TextEditingController();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/homepage': (context) => const HomePage(),
      },
    );
  }
}

//LANDONG
class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/icon3.png',
              width: 200.0,
              height: 200.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 50.0),
            const Text(
              'Your order is our priority',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'We are offering our customers\na fast and free delivery',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 30.0),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green[900],
                  minimumSize: const Size(60.0, 30.0),
                ),
                child: const Text('GET STARTED'),
              ),
            ),
          ], //Children
        ),
      ),
    );
  }
}

//LOGIN PAGE
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isVerified = true;
  bool showInvalidPassword = false;
  bool showInvalidUsername = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50.0),
            Image.asset(
              'lib/assets/images/icon2.png',
              width: 150.0,
              height: 150.0,
            ),
            const SizedBox(height: 40.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Username',
                filled: false,
                fillColor: Colors.white,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[400]!),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                filled: false,
                fillColor: Colors.white,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[400]!),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Do not have an account yet?',
              textAlign: TextAlign.center,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                'Sign Up here',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            if (showInvalidUsername)
              const Text(
                'Invalid username',
                style: TextStyle(color: Colors.red),
              ),
            if (showInvalidPassword)
              const Text(
                'Invalid password',
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: isVerified
                        ? () {
                            _getUserFromFirestore(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green[900],
                      minimumSize: const Size(60.0, 30.0),
                    ),
                    child: const Text('LOGIN'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getUserFromFirestore(BuildContext context) async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userData = querySnapshot.docs[0].data();
      final savedPassword = userData['password'];

      if (savedPassword == password) {
        print('Logged in successfully');
        setState(() {
          isVerified = true;
        });
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const HomePage(),
        //   ),
        // );
      } else {
        print('Invalid password');
        setState(() {
          //isVerified = false;
          showInvalidPassword = true;
        });
      }
    } else {
      print('Invalid username');
      setState(() {
        //isVerified = false;
        showInvalidUsername = true;
        showInvalidPassword = false;
      });
      // Use Navigator to navigate to the HomePage
      Future.delayed(Duration.zero, () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HomePage(),
          ),
        );
      });
    }
  }
}

//SIGNUP PAGE
class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50.0),
            Image.asset(
              'lib/assets/images/icon1.png',
              width: 150.0,
              height: 150.0,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Username',
                filled: false,
                fillColor: Colors.white,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[400]!),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email address',
                filled: false,
                fillColor: Colors.white,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[400]!),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                filled: false,
                fillColor: Colors.white,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[900]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green[400]!),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Already have an account?',
              textAlign: TextAlign.center,
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text(
                'Login here',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _createUserInFirestore();
                  Navigator.pushNamed(context, '/homepage');
                },
                style: ElevatedButton.styleFrom(),
                child: const Text('SIGN UP'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _createUserInFirestore() async {
  final username = _usernameController.text;
  final email = _emailController.text;
  final password = _passwordController.text;

  try {
    await FirebaseFirestore.instance.collection('users').add({
      'username': username,
      'email': email,
      'password': password,
    });
  } catch (e) {
    print('Error creating user: $e');
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/icon3.png',
              width: 200.0,
              height: 200.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 50.0),
            const Text(
              'This is the Home Screen',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'You already login to this app',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(),
                child: const Text('logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
