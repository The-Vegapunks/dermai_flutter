import 'package:dermai/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dermai/features/core/presentation/privacy_policy.dart';
import 'package:dermai/features/core/presentation/terms_conditions.dart';
import 'package:dermai/features/core/presentation/textfields.dart';
import 'package:dermai/features/patient/presentation/pages/root_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool? _isPrivacyPolicyChecked = false;
  String? _name;
  String? _email;
  String? _password;
  String? _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
          if (state is AuthSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const RootPage(),
                ),
                (Route<dynamic> route) => false);
          }
        },
        builder: (context, state) {
          return AbsorbPointer(
            absorbing: state is AuthLoading,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar.large(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: MaterialLocalizations.of(context)
                        .backButtonTooltip,
                  ),
                  title: const Text('Sign Up'),
                ),
                SliverToBoxAdapter(
                  child: Column(children: [
                    const SizedBox(height: 32),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: UniversalTextField(
                        maxLines: 1,
                        labelText: "Full Name",
                        icon: const Icon(Icons.person),
                        onChanged: (value) => {
                          setState(() {
                            _name = value;
                          })
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16),
                        child: EmailTextField(
                          onChanged: (value) => {_email = value},
                        )),
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: ObscuredTextField(
                        labelText: 'Password',
                        icon: const Icon(Icons.lock_outline),
                        onChanged: (value) => {_password = value},
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: ObscuredTextField(
                        labelText: 'Confirm Password',
                        icon: const Icon(Icons.lock),
                        onChanged: (value) =>
                            {_confirmPassword = value},
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              value: _isPrivacyPolicyChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isPrivacyPolicyChecked = value;
                                });
                              }),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium,
                                children: <TextSpan>[
                                  const TextSpan(
                                      text:
                                          'By joining, you agree to our '),
                                  TextSpan(
                                      text: 'Terms of Service',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)
                                          .copyWith(
                                              decoration:
                                                  TextDecoration
                                                      .underline,
                                              decorationColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              const TermsConditions()));
                                            }),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                      text: 'Privacy Policy',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary)
                                          .copyWith(
                                              decoration:
                                                  TextDecoration
                                                      .underline,
                                              decorationColor:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                      recognizer:
                                          TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                              const PrivacyPolicy()));
                                            }),
                                  const TextSpan(text: '.'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const Expanded(child: SizedBox(height: 16)),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_isPrivacyPolicyChecked ==
                                      true) {
                                    if (_validateInputs()) {
                                      context
                                          .read<AuthBloc>()
                                          .add(AuthSignUp(
                                            name: _name!.trim(),
                                            email: _email!.trim(),
                                            password:
                                                _password!.trim(),
                                          ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please agree to the Terms of Service and Privacy Policy.'),
                                      ),
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    const Text('Sign Up'),
                                    if (state is AuthLoading)
                                      const SizedBox(width: 8),
                                    if (state is AuthLoading)
                                      const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _validateInputs() {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (_name == null || _name!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your full name.'),
        ),
      );
      return false;
    }

    if (_email == null || _email!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email.'),
        ),
      );
      return false;
    }
    if (!emailRegex.hasMatch(_email!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address.'),
        ),
      );
      return false;
    }

    if (_password == null || _password!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password.'),
        ),
      );
      return false;
    }
    if (_confirmPassword == null || _confirmPassword!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please confirm your password.'),
        ),
      );
      return false;
    }
    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
        ),
      );
      return false;
    }
    return true;
  }
}
