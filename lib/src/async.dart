import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactives/reactives.dart';

class ReactiveFuture<T> extends Reactive {
  final Future<T> future;

  AsyncSnapshot<T> _snapshot = const AsyncSnapshot.waiting();
  AsyncSnapshot get snapshot => _snapshot;

  ReactiveFuture(
    ReactiveHost host,
    this.future, {
    T? initialData,
    void Function(AsyncSnapshot<T>)? listener,
  }) : super(host) {
    if (initialData != null) {
      _snapshot = AsyncSnapshot.withData(ConnectionState.waiting, initialData);
    }

    future.then((data) {
      _snapshot = AsyncSnapshot.withData(ConnectionState.done, data);
      if (listener != null) {
        listener(_snapshot);
      } else {
        host.requestUpdate();
      }
    }, onError: (err, st) {
      _snapshot = AsyncSnapshot.withError(ConnectionState.done, err, st);
      if (listener != null) {
        listener(_snapshot);
      } else {
        host.requestUpdate();
      }
    });
  }
}

class ReactiveStream<T> extends Reactive {
  final Stream<T> stream;

  AsyncSnapshot<T> _snapshot = const AsyncSnapshot.waiting();
  AsyncSnapshot get snapshot => _snapshot;

  StreamSubscription<T>? _subscription;

  @protected
  final void Function(AsyncSnapshot<T>)? listener;

  ReactiveStream(
    ReactiveHost host,
    this.stream, {
    T? initialData,
    this.listener,
  }) : super(host) {
    if (initialData != null) {
      _snapshot = AsyncSnapshot.withData(ConnectionState.waiting, initialData);
    }

    _subscription = stream.listen((T data) {
      _snapshot = afterData(_snapshot, data);
      _onChange();
    }, onError: (Object error, StackTrace stackTrace) {
      _snapshot = afterError(_snapshot, error, stackTrace);
      _onChange();
    }, onDone: () {
      _snapshot = afterDone(_snapshot);
      _onChange();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    super.dispose();
  }

  void _onChange() {
    final lis = listener;
    if (lis != null) {
      lis(_snapshot);
    } else {
      host.requestUpdate();
    }
  }

  AsyncSnapshot<T> afterConnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.waiting);

  AsyncSnapshot<T> afterData(AsyncSnapshot<T> current, T data) {
    return AsyncSnapshot<T>.withData(ConnectionState.active, data);
  }

  AsyncSnapshot<T> afterError(
      AsyncSnapshot<T> current, Object error, StackTrace stackTrace) {
    return AsyncSnapshot<T>.withError(
        ConnectionState.active, error, stackTrace);
  }

  AsyncSnapshot<T> afterDone(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.done);

  AsyncSnapshot<T> afterDisconnected(AsyncSnapshot<T> current) =>
      current.inState(ConnectionState.none);
}
