import 'package:flutter/material.dart';
import 'package:reactives/src/ticker.dart';
import 'reactive.dart';

class ReactiveAnimationController extends Reactive
    with SingleTickerProviderReactiveMixin
    implements TickerProvider {
  final bool _listen;
  late final AnimationController ctrl;

  ReactiveAnimationController(
    ReactiveHost host, {
    AnimationController? ctrl,
    bool listen = false,
  })  : _listen = listen,
        super(host) {
    this.ctrl = ctrl ?? AnimationController(vsync: this);
    if (_listen) this.ctrl.addListener(_onChange);
  }

  void _onChange() {
    host.requestUpdate();
  }

  @override
  void dispose() {
    if (_listen) ctrl.removeListener(_onChange);
    ctrl.dispose();
    super.dispose();
  }
}

class ReactiveAnimation<T> extends Reactive {
  final Animation<T> animation;
  final VoidCallback? listener;
  ReactiveAnimation(
    ReactiveHost host, {
    required this.animation,
    this.listener,
  }) : super(host) {
    animation.addListener(listener ?? _onChange);
  }

  void _onChange() {
    host.requestUpdate();
  }

  @override
  void dispose() {
    animation.removeListener(listener ?? _onChange);
    super.dispose();
  }
}
