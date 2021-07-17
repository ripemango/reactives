import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reactives/reactives.dart';

void main() {}

class AwesomeWidget extends StatefulWidget {
  const AwesomeWidget({Key? key}) : super(key: key);

  @override
  _AwesomeWidgetState createState() => _AwesomeWidgetState();
}

class _AwesomeWidgetState extends State<AwesomeWidget>
    with TickerProviderStateMixin {
  late final TextEditingController emailCtrl;
  late final TextEditingController passwordCtrl;
  late final AnimationController entryAnimation;
  late final AnimationController highLightAnimation;

  @override
  void initState() {
    super.initState();
    emailCtrl = TextEditingController();
    passwordCtrl = TextEditingController();
    entryAnimation = AnimationController(vsync: this);
    highLightAnimation = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    entryAnimation.dispose();
    highLightAnimation.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AwesomeReactiveWidget extends StatefulWidget {
  const AwesomeReactiveWidget({Key? key}) : super(key: key);

  @override
  _AwesomeReactiveWidgetState createState() => _AwesomeReactiveWidgetState();
}

class _AwesomeReactiveWidgetState extends State<AwesomeReactiveWidget>
    with TickerProviderStateMixin, ReactiveHostMixin {
  late final emailCtrl = TextEditingReactive(this);
  late final passwordCtrl = TextEditingReactive(this);
  late final entryAnimation = AnimationReactive(this);
  late final exitAnimation = AnimationReactive(this);

  @override
  Widget build(BuildContext context) {
    return Container(
        // ....
    );
  }
}
