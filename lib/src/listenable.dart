import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'reactive.dart';

class ListenableReactive<T extends Listenable> extends Reactive {
  final T listenable;
  final bool listen;
  final VoidCallback? listener;

  ListenableReactive(
    ReactiveHost host,
    this.listenable, {
    this.listen = false,
    this.listener,
  }) : super(host) {
    if (listen || listener != null) {
      listenable.addListener(listener ?? host.requestUpdate);
    }
  }

  @override
  void dispose() {
    GlobalKey();
    if (listen || listener != null) {
      listenable.removeListener(listener ?? host.requestUpdate);
    }
    super.dispose();
  }
}
