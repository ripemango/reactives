import 'package:flutter/material.dart';
import 'package:reactives/reactives.dart';

/// Simple widget showing reactive
class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

// Add the ReactiveHostMixin
class _LoginWidgetState extends State<LoginWidget> with ReactiveHostMixin {
  // Create required reactives
  late final emailCtrl = ReactiveTextEditingController(this).ctrl;
  late final passwordCtrl = ReactiveTextEditingController(this).ctrl;

  var passwordVisible = false;

  void submit() {
    // Login logic
  }

  void toggeVisible() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Use the reactives just like any field
        TextField(controller: emailCtrl),
        TextField(
          controller: passwordCtrl,
          decoration: InputDecoration(
            suffix: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: toggeVisible,
            ),
          ),
          obscureText: !passwordVisible,
        ),
        ElevatedButton(
          child: const Text('Login'),
          onPressed: submit,
        ),
      ],
    );
  }
}

/// ReactiveLogin is a way to extract the login logic out of the widget for
/// testability and resusability
class ReactiveLogin extends Reactive {
  final ReactiveTextEditingController _email;
  final ReactiveTextEditingController _password;

  TextEditingController get emailCtrl => _email.ctrl;
  TextEditingController get passwordCtrl => _password.ctrl;

  bool _passwordVisible = false;
  bool get passwordVisible => _passwordVisible;

  ReactiveLogin(ReactiveHost host)
      : _email = ReactiveTextEditingController(host),
        _password = ReactiveTextEditingController(host),
        super(host);

  void submit() {
    // Login logic
  }

  void toggleVisible() {
    _passwordVisible = !_passwordVisible;
    host.requestUpdate(); // Calls setState
  }
}

/// The above example can be rewritten using our extracted login logic
/// This reduces the Widget the UI logic
class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

// Add the ReactiveHostMixin
class _LoginViewState extends State<LoginView> with ReactiveHostMixin {
  // Create required login Reactive
  late final login = ReactiveLogin(this);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Use the reactives just like any field
        TextField(controller: login.emailCtrl),
        TextField(
          controller: login.passwordCtrl,
          decoration: InputDecoration(
            suffix: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: login.toggleVisible,
            ),
          ),
          obscureText: !login.passwordVisible,
        ),
        ElevatedButton(child: const Text('Login'), onPressed: login.submit),
      ],
    );
  }
}
