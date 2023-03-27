// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';

enum FirestoreResultStatus {
  undefined,
}

class FirestoreExceptionHandler {
  static handleException(e) {
    print(e.code);
    var status;
    switch (e.code) {
      default:
        status = FirestoreResultStatus.undefined;
    }
    return status;
  }

  ///
  /// Accepts AuthExceptionHandler.errorType
  ///
  static generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}

/// Generic exception related to Firebase Authentication. Check the error code
/// and message for more details.
class FirebaseCustomException extends FirebaseException implements Exception {
  @protected
  FirebaseCustomException({
    required this.message,
    required this.code,
  }) : super(plugin: 'firebase_auth', message: message, code: code);

  /// Unique error code
  final String code;

  /// Complete error message.
  final String message;
}
