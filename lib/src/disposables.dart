import 'package:flutter/material.dart';
import 'package:reactives/reactives.dart';
import 'package:reactives/src/ticker.dart';


abstract class Disposable {
  void dispose();
}

/// {@template disposable}
/// Optinally creates and disposes a [FocusNode].
/// {@endtemplate}

/// {@macro disposable} [FocusNode].
class ReactiveFocusNode extends Reactive {
  final FocusNode node;
  ReactiveFocusNode(
    ReactiveHost host, {
    FocusNode? node,
  })  : node = node ?? FocusNode(),
        super(host);

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }
}

/// {@macro disposable} [TextEditingController].
class ReactiveTextEditingController extends Reactive {
  /// The [TextEditingController] that will be disposed.
  final TextEditingController ctrl;

  ReactiveTextEditingController(
    ReactiveHost host, {
    TextEditingController? ctrl,
  })  : ctrl = ctrl ?? TextEditingController(),
        super(host);

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }
}

/// {@macro disposable} [PageController].
class ReactivePageController extends ReactiveScrollController {
  @override
  PageController get ctrl => super.ctrl as PageController;

  ReactivePageController(
    ReactiveHost host, {
    PageController? ctrl,
    bool listen = false,
    VoidCallback? listener,
  }) : super(host, ctrl: ctrl, listen: listen, listener: listener);
}

/// Creates and disposes a [TabController].
class ReactiveTabController extends Reactive
    with SingleTickerProviderReactiveMixin {
  late final TabController ctrl;
  ReactiveTabController(
    ReactiveHost host, {
    int initialIndex = 0,
    required int length,
    bool listen = false,
    VoidCallback? listener,
  }) : super(host) {
    ctrl = TabController(
      initialIndex: initialIndex,
      length: length,
      vsync: this,
    );
    ReactiveListenable(host, ctrl, listen: listen, listener: listener);
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }
}

/// {@macro disposable} [ScrollController].
class ReactiveScrollController extends Reactive {
  final ScrollController ctrl;
  ReactiveScrollController(
    ReactiveHost host, {
    ScrollController? ctrl,
    bool listen = false,
    VoidCallback? listener,
  })  : ctrl = ctrl ?? ScrollController(),
        super(host) {
    ReactiveListenable(host, this.ctrl, listen: listen, listener: listener);
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }
}
