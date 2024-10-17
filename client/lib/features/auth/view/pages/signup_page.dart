import 'package:client/core/theme/app_color.dart';
import 'package:client/core/widget/loader.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/core/widget/auth_gradient_button.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/core/utils/utils.dart';
import 'package:client/helper/logcat.dart';
import 'package:client/repositories/auth_remote_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widget/custom_field.dart';
import '../../../../routes/navigator.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String email = 'aks@gmail.com';
  String pass = 'aks123';

  @override
  void initState() {
    super.initState();
    _emailController.text = email;
    _passwordController.text = pass;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        authViewModelProvider.select((value) => value?.isLoading == true));
    logCat(isLoading);

    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            customSnackBar(
                context: context, msg: 'Account created successfully');
            popPage(context);
          },
          error: (error, stackTrace) =>
              customSnackBar(context: context, msg: error.toString()),
          loading: () {},
        );
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: Visibility(
        child: Loader(),
        visible: isLoading,
        replacement: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 50,
                  ),
                ),
                SizedBox(height: 15),
                CustomField(
                  hintText: 'Name',
                  controller: _nameController,
                ),
                SizedBox(height: 15),
                CustomField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                CustomField(
                  hintText: 'Password',
                  controller: _passwordController,
                  isObscureText: true,
                ),
                SizedBox(height: 20),
                AuthGradientButton(
                  text: 'Sign Up',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await ref.read(authViewModelProvider.notifier).signUpUser(
                          name: _nameController.text,
                          email: _emailController.text,
                          password: _passwordController.text);
                    } else {
                      customSnackBar(
                          context: context, msg: 'Input filed is missing');
                    }
                  },
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => popPage(context),
                  child: RichText(
                    text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: const [
                          TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: AppColor.gradient2,
                              )),
                        ]),
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
