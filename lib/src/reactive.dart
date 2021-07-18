import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The base class for reactives. Providing handy callbacks.
///
/// New reactives need to extend this class and override callbacks
/// as needed
abstract class Reactive with Diagnosticable {
  @protected
  final ReactiveHost host;

  Reactive(this.host) {
    host.addController(this);
  }

  @protected
  @mustCallSuper
  void didChangeDependencies() {}

  @protected
  @mustCallSuper
  void dispose() {
    host.removeController(this);
  }

  void didUpdateWidget(covariant StatefulWidget oldWidget) {}

  @protected
  @mustCallSuper
  void activate() {}

  @protected
  @mustCallSuper
  void deactivate() {}
}

/// The interafce required for reactive controller hosts
/// See [ReactiveHostMixin] for a mixin that implements this interface.
abstract class ReactiveHost {
  addController(Reactive ctrl);
  removeController(Reactive ctrl);
  requestUpdate();
  Future<void> get updateComplete;
  BuildContext get context;
}

/// Turns any state class to a [ReactiveHost]
///
/// ```dart
/// class MyWidget extends StatefulWidget {
///   const MyWidget({Key? key}) : super(key: key);
///
///   @override
///   _MyWidgetState createState() => _MyWidgetState();
/// }
///
/// class _MyWidgetState extends State<MyWidget> with ReactiveBindings {
///   @override
///   Widget build(BuildContext context) {
///     return Container();
///   }
/// }
/// ```
///
mixin ReactiveHostMixin<T extends StatefulWidget> on State<T>
    implements ReactiveHost {
  // API
  @protected
  final List<Reactive> reactives = [];

  @override
  addController(Reactive ctrl) {
    reactives.add(ctrl);
  }

  @override
  removeController(Reactive ctrl) {
    reactives.remove(ctrl);
  }

  @override
  requestUpdate() {
    setState(() {});
  }

  @override
  Future<void> get updateComplete {
    final completer = Completer();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      completer.complete();
    });
    return completer.future;
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    for (final ctrl in reactives) {
      ctrl.didUpdateWidget(oldWidget);
    }
  }

  // Callbacks
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final ctrl in reactives) {
      ctrl.didChangeDependencies();
    }
  }

  @override
  void activate() {
    super.activate();
    for (final ctrl in reactives) {
      ctrl.activate();
    }
  }

  @override
  void deactivate() {
    for (final ctrl in reactives) {
      ctrl.deactivate();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    for (final ctrl in reactives) {
      ctrl.dispose();
    }
    super.dispose();
  }
}
