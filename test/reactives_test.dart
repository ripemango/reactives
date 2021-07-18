import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:reactives/reactives.dart';

void main() {}

class AwesomeWidget extends StatefulWidget {
  const AwesomeWidget({Key? key}) : super(key: key);

  @override
  _AwesomeWidgetState createState() => _AwesomeWidgetState();
}

class _AwesomeWidgetState extends State<AwesomeWidget> with ReactiveHostMixin {
  late final textReactive = ReactiveTextEditingController(this);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: textReactive.ctrl,
      ),
    );
  }
}
