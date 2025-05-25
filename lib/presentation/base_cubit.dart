import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

abstract class BaseCubit<TState> extends Cubit<TState> {
  BaseCubit(super.initialState);

  @override
  Future<void> close() async {
    _subscriptions.forEach((key, subscription) {
      try {
        subscription.cancel();
      } catch (error) {
        log('!!! Error while close subscription');
      }
    });
    await super.close();
  }

  final Map<String, StreamSubscription<dynamic>> _subscriptions = {};

  void handleError(String errorMessage);

  Future<void> performSafeAction(AsyncValueGetter callback) async {
    try {
      return await callback();
    } catch (exception) {
      handleError('$exception');
      log('$exception');
    }
  }

  backgroundJob<T>(
    Future<dynamic> toExecute,
    dynamic actionSuccess,
    VoidCallback actionError, {
    String? textCodeError,
    bool isAutoShowPopup = false,
    bool isAutoShowSnackbar = false,
  }) async {
    try {
      final data = await toExecute;
      actionSuccess(data);
    } catch (error) {
      actionError();
      handleError('$error');
    }
  }

  void handleStream<T>(
    String key,
    Stream<T> stream,
    ValueSetter<T> actionSuccess, {
    ValueSetter<String>? onError,
    bool isAutoShowSnackbar = false,
  }) {
    _subscriptions[key]?.cancel();
    _subscriptions[key] = stream.listen(
      (T data) async {
        actionSuccess(data);
      },
      onError: (Object error) {
        handleError(error.toString());
      },
    );
  }
}
