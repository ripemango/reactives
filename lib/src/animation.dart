import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'reactive.dart';

class AnimationReactive extends Reactive implements TickerProvider {
  final bool _listen;
  late final AnimationController ctrl;
  Ticker? _ticker;

  AnimationReactive(
    ReactiveHost host, {
    AnimationController? ctrl,
    bool listen = false,
  })  : _listen = listen,
        super(host) {
    this.ctrl = ctrl ?? AnimationController(vsync: this);
  }

  @override
  @protected
  Ticker createTicker(TickerCallback onTick) {
    _ticker = Ticker(
      onTick,
      debugLabel: kDebugMode ? 'created by ${describeIdentity(this)}' : null,
    );
    // We assume that this is called from initState, build, or some sort of
    // event handler, and that thus TickerMode.of(context) would return true. We
    // can't actually check that here because if we're in initState then we're
    // not allowed to do inheritance checks yet.
    return _ticker!;
  }

  void _onChange() {
    host.requestUpdate();
  }

  @override
  void didChangeDependencies() {
    if (_ticker != null) _ticker!.muted = !TickerMode.of(host.context);
    super.didChangeDependencies();
  }

  @override
  void activate() {
    super.activate();
    if (_listen) ctrl.addListener(_onChange);
  }

  @override
  void deactivate() {
    if (_listen) ctrl.removeListener(_onChange);
    super.deactivate();
  }

  @override
  void dispose() {
    ctrl.dispose();
    assert(() {
      if (_ticker == null || !_ticker!.isActive) return true;
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('$this was disposed with an active Ticker.'),
        ErrorDescription(
          '$runtimeType created a Ticker via its SingleTickerProviderStateMixin, but at the time '
          'dispose() was called on the mixin, that Ticker was still active. The Ticker must '
          'be disposed before calling super.dispose().',
        ),
        ErrorHint(
          'Tickers used by AnimationControllers '
          'should be disposed by calling dispose() on the AnimationController itself. '
          'Otherwise, the ticker will leak.',
        ),
        _ticker!.describeForError('The offending ticker was'),
      ]);
    }());
    super.dispose();
  }
}
