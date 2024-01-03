import 'package:auth/auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_order_app/models/user.dart';
import 'package:food_order_app/states_management/auth/auth_cubit.dart';
import 'package:food_order_app/states_management/auth/auth_state.dart';
import 'package:food_order_app/ui/pages/auth/auth_page_adapter.dart';
import 'package:food_order_app/ui/widgets/custom_flat_button.dart';
import 'package:food_order_app/ui/widgets/custom_outline_button.dart';
import 'package:food_order_app/ui/widgets/custom_text_field.dart';

class AuthPage extends StatefulWidget {
  final AuthManager _manager;
  final ISignUpService _signUpService;
  final IAuthPageAdaper _adapter;

  const AuthPage(this._manager, this._signUpService, this._adapter,
      {super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final PageController _controller = PageController();
  String _username = "";
  String _email = "";
  String _password = "";
  IAuthService? service;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 110),
                child: _buildLogo(),
              ),
              const SizedBox(
                height: 50,
              ),
              BlocConsumer<AuthCubit, AuthState>(builder: (_, state) {
                return _buildUI();
              }, listener: (context, state) {
                if (state is LoadingState) {
                  _showLoader();
                }
                if (state is AuthSuccessState) {
                  widget._adapter.onAuthSuccess(context, service!);
                }
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.message,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  );
                  _hideLoader();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  _buildLogo() => Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              fit: BoxFit.fill,
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: "Food",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: " Space",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  )
                ],
              ),
            )
          ],
        ),
      );
  _buildUI() => SizedBox(
        height: 500,
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: [
            _signIn(),
            _signUp(),
          ],
        ),
      );
  _signUp() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            CustomTextField(
              inputAction: TextInputAction.next,
              hint: "Username",
              fontSize: 18,
              fontWeight: FontWeight.normal,
              onChanged: (val) {
                _username = val;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ..._emailAndPassword(),
            const SizedBox(
              height: 30,
            ),
            CustomFlatButton(
                text: 'Sign up',
                size: const Size(double.infinity, 54),
                onPressed: () {
                  final user =
                      User(name: _username, email: _email, password: _password);
                  BlocProvider.of<AuthCubit>(context)
                      .signup(widget._signUpService, user);
                }),
            const SizedBox(
              height: 30,
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
              text: TextSpan(
                  text: 'Already have an account?',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                  children: [
                    TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.elasticOut,
                            );
                          })
                  ]),
            )
          ],
        ),
      );
  _signIn() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            ..._emailAndPassword(),
            const SizedBox(
              height: 30,
            ),
            CustomFlatButton(
                text: 'Sign in',
                size: const Size(double.infinity, 54),
                onPressed: () {
                  service = widget._manager.service(AuthType.email);
                  (service as EmailAuth)
                      .credential(email: _email, password: _password);
                  BlocProvider.of<AuthCubit>(context)
                      .signin(service!, AuthType.email);
                }),
            const SizedBox(
              height: 30,
            ),
            CustomOutlineButton(
              text: 'Sign in with google',
              size: const Size(double.infinity, 50),
              icon: SvgPicture.asset(
                'assets/google-icon.svg',
                height: 18,
                width: 18,
                fit: BoxFit.fill,
              ),
              onPressed: () {
                service = widget._manager.service(AuthType.google);
                BlocProvider.of<AuthCubit>(context)
                    .signin(service!, AuthType.google);
              },
            ),
            const SizedBox(
              height: 30,
            ),
            RichText(
              text: TextSpan(
                  text: 'Dont\'t have an account?',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                  children: [
                    TextSpan(
                        text: 'Sign up',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.elasticOut,
                            );
                          })
                  ]),
            )
          ],
        ),
      );
  List<Widget> _emailAndPassword() => [
        CustomTextField(
          keyboardType: TextInputType.emailAddress,
          inputAction: TextInputAction.next,
          hint: 'Email',
          fontSize: 18,
          fontWeight: FontWeight.normal,
          onChanged: (val) {
            _email = val;
          },
        ),
        const SizedBox(
          height: 30,
        ),
        CustomTextField(
          obscure: true,
          inputAction: TextInputAction.done,
          hint: 'Password',
          fontSize: 18,
          fontWeight: FontWeight.normal,
          onChanged: (val) {
            _password = val;
          },
        ),
      ];
  _showLoader() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) => const AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: CircularProgressIndicator(
                color: Colors.white70,
              ),
            ));
  }

  _hideLoader() {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
