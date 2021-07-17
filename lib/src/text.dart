import 'package:flutter/widgets.dart';
import 'reactive.dart';

/// Provides a [TextEditingController]. See [ctrl]
class TextEditingReactive extends Reactive {
  /// The [TextEditingController]
  late final TextEditingController ctrl;

  TextEditingReactive(
    ReactiveHost host, {
    TextEditingController? ctrl,
  }) : super(host) {
    this.ctrl = ctrl ?? TextEditingController();
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }
}
