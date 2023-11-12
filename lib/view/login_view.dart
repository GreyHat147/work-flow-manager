import 'package:flutter/material.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.calendar_month,
                      size: 100, color: AppTheme.grey),
                  const SizedBox(height: 30),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Work Flow Manager App',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.appColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                  CustomTextField(
                    labelText: 'Correo electrónico',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 40),
                  CustomTextField(
                    labelText: 'Contraseña',
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    //obscureText: true,
                  ),
                  const SizedBox(height: 70),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        // Change your radius here
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: AppTheme.appColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 20),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Iniciar sesión',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
