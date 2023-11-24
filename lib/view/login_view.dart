import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_flow_manager/app_theme.dart';
import 'package:work_flow_manager/injections.dart';
import 'package:work_flow_manager/repository/auth/auth_respository.dart';
import 'package:work_flow_manager/view/widgets/widgets.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _login(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthRepository>().login(
            emailController.text,
            passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthRepository>(),
      child: BlocConsumer<AuthRepository, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded && state.msgError.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.msgError),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppTheme.background,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.calendar_month,
                            size: 100, color: AppTheme.grey),
                        const SizedBox(height: 30),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Work Flow Manager',
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
                          checkEmail: true,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: AppTheme.appColor,
                          ),
                        ),
                        const SizedBox(height: 40),
                        CustomTextField(
                          labelText: 'Contraseña',
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          prefixIcon: const Icon(
                            Icons.password,
                            color: AppTheme.appColor,
                          ),
                          obscureText: true,
                          maxLines: 1,
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
                          onPressed: () => _login(context),
                          child: const Text(
                            'Iniciar sesión',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
