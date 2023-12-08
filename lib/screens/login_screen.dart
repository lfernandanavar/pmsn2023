import 'package:flutter/material.dart';
import 'package:pmsn20232/widgets/checkbox_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: const Color(0xFFDD969C),
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            opacity: .8,
            fit: BoxFit.fill,
            image: NetworkImage(
                'https://w0.peakpx.com/wallpaper/389/270/HD-wallpaper-sword-world-cool-fantasy.jpg')),
      ),
      child: SafeArea(
        child: Center(
          child: SizedBox(
            width: size.width * 0.76,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // username
                const Text('Login Page',
                    style: TextStyle(
                      color: Color(0xFF221133),
                      fontSize: 30,
                    )),
                _buildInputText(
                    'email', TextInputType.emailAddress, emailController),
                // pasword
                _buildInputText('password', TextInputType.visiblePassword,
                    passwordController,
                    isPassword: true),
                // Button
                const SizedBox(height: 50),
                Row(
                  children: [
                    const Text('Keep sign'),
                    const CheckBoxWidget(),
                    Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              if ((emailController.text == "admin") &&
                                  (passwordController.text == "1234")) {
                                Navigator.pushNamed(context, '/dash');
                              }
                            },
                            child: const Text('Login'))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }

  TextField _buildInputText(name, inputType, controller, {isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      decoration: InputDecoration(
          suffixIcon: isPassword
              ? const Icon(Icons.remove_red_eye)
              : const Icon(Icons.done),
          labelText: name,
          labelStyle:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          floatingLabelAlignment: FloatingLabelAlignment.start),
      onChanged: (value) {},
    );
  }
}
