import 'package:flutter/material.dart';
import 'package:md_engine/src/core/util/md_view_error_event.dart';

import '../../../md_engine.dart';

class GlobalErrorObserver {
  static ErrorStateObsListener? _listener = _errorListener;
  static set listen(ErrorStateObsListener listener) => _listener = listener;
  static bool _isLocked = false;

  static Future<void> dispatch(
    Object error,
    StackTrace stackTrace,
    MdViewErrorEvent? viewError,
  ) async {
    if (_listener != null) {
      if (viewError == null || !(await viewError.onShow(error, stackTrace))) {
        _listener!(error, stackTrace, (err) {
          viewError?.onGlobalBack(err);
        });
      }
    }
  }

  static BuildContext get ctx => QR.context!;

  static Future<void> _errorListener(
    error,
    stackTrace,
    ErrorOnBackCallback? onBack,
  ) async {
    if (_isLocked) {
      return;
    }

    await Future.delayed(const Duration(milliseconds: 50));
    var reason =
        error is MdHttpDriverServerFailure ? error.message : error.toString();
    reason = "$reason\n\n$stackTrace";
    if (error is MdHttpDriverNetworkFailure) {
      _isLocked = true;
      await MdDialog(
        // ignore: use_build_context_synchronously
        title: "shared.failure.connection.title".tr(ctx),
        // ignore: use_build_context_synchronously
        message: "shared.failure.connection.message".tr(ctx),
        body: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: MdFailureMoreDetails(
            message: reason,
          ),
        ),
        marginBottom: 0,
        onTap: () {
          Navigator.of(ctx).pop();
          onBack?.call(error);
        },
        // ignore: use_build_context_synchronously
        buttonText: "shared.i_understood".tr(ctx),
      ).show(QR.context!);
      _isLocked = false;
    } else if ((error is MdHttpDriverServerFailure) || error is! MdFailure) {
      _isLocked = true;
      await MdDialog(
        // ignore: use_build_context_synchronously
        title: "shared.failure.unexpected.title".tr(ctx),
        // ignore: use_build_context_synchronously
        message: "shared.failure.unexpected.message".tr(ctx),
        body: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: MdFailureMoreDetails(
            message: reason,
          ),
        ),
        marginBottom: 0,
        onTap: () {
          Navigator.of(ctx).pop();
          onBack?.call(error);
        },
        // ignore: use_build_context_synchronously
        buttonText: "shared.i_understood".tr(ctx),
      ).show(QR.context!);
      _isLocked = false;
    } else if (error is MdHttpDriverServerBadResponseFailure) {
      _isLocked = true;
      await MdDialog(
        // ignore: use_build_context_synchronously
        title: "shared.attention".tr(ctx),
        message: error.message,
        // ignore: use_build_context_synchronously
        buttonText: "shared.i_understood".tr(ctx),
        body: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: MdFailureMoreDetails(
            message: reason,
          ),
        ),
        marginBottom: 0,
        onTap: () {
          Navigator.of(ctx).pop();
          onBack?.call(error);
        },
      ).show(QR.context!);
      _isLocked = false;
    }
  }
}
