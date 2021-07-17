import 'package:flutter/widgets.dart';

import 'reactive.dart';

class FocusNodeReactive extends Reactive {
  late final FocusNode node;
  FocusNodeReactive(
    ReactiveHost host, {
    FocusNode? node,
  }) : super(host) {
    node = node ?? FocusNode();
  }

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }
}
