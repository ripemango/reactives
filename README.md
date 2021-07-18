# reactives

A new way for Flutter to reuse/group common logic. Think of them like React hooks but for and of flutter.

Idea copied from the [lit world](https://lit.dev/docs/composition/controllers/)

## Motive

Have you ever written code like this?

```dart
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
```

There are a couple of problems here. Most of the object management logic is generic and can be reused. It is extremely easy to forget that one `dispose` call. Using reactives this gets transformed to


```dart
class AwesomeReactiveWidget extends StatefulWidget {
  const AwesomeReactiveWidget({Key? key}) : super(key: key);

  @override
  _AwesomeReactiveWidgetState createState() => _AwesomeReactiveWidgetState();
}

class _AwesomeReactiveWidgetState extends State<AwesomeReactiveWidget> with ReactiveHostMixin {
  late final emailCtrl = ReactiveTextEditingController(this);
  late final passwordCtrl = ReactiveTextEditingController(this);
  late final entryAnimation = ReactiveAnimationController(this);
  late final exitAnimation = ReactiveAnimationController(this);

  @override
  Widget build(BuildContext context) {
    return Container(
        // ....
    );
  }
}
```

### Comparision to [flutter_hooks](https://pub.dev/packages/flutter_hooks):

From a user perspective `flutter_hooks` is a replacement for `StatefulWidget`.  `reactives` is not. If you look at the code for `ReactiveHostMixin` it is about 60 lines (blank lines included). Reactives do not try to replace `StatefulWidget`, it just solves the reusability problem inherent due to mixin's "is-a" relationship. Reactives have a "has-a" relationship.

There are no new rules to writing reactives. See examples of existing reactives. It is basically the same logic isolated in a different class.
For the same reason it doesn't need a lot of the hooks like `useState` which would be needed if tried to replace `StatefulWidget`.

The learning curve of reactives is next to negligible. Hooks need you to learn a few concepts and [how to/not to](https://pub.dev/packages/flutter_hooks#rules) do things. It also requires you to transform entire widgets. Reactives can be adapted incrementally even for a single widget.