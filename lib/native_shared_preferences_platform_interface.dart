// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

import 'method_channel_native_shared_preferences.dart';

/// The interface that implementations of shared_preferences must implement.
///
/// Platform implementations should extend this class rather than implement it as `shared_preferences`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [NativeSharedPreferencesStorePlatform] methods.
abstract class NativeSharedPreferencesStorePlatform
    extends SharedPreferencesStorePlatform {
  /// The default instance of [NativeSharedPreferencesStorePlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeSharedPreferencesStore].
  static NativeSharedPreferencesStorePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [NativeSharedPreferencesStorePlatform] when they register themselves.
  static set instance(NativeSharedPreferencesStorePlatform value) {
    if (!value.isMock) {
      try {
        value._verifyProvidesDefaultImplementations();
      } on NoSuchMethodError catch (_) {
        throw AssertionError(
            'Platform interfaces must not be implemented with `implements`');
      }
    }
    _instance = value;
  }

  static NativeSharedPreferencesStorePlatform _instance =
      MethodChannelNativeSharedPreferencesStore();

  /// Only mock implementations should set this to true.
  ///
  /// Mockito mocks are implementing this class with `implements` which is forbidden for anything
  /// other than mocks (see class docs). This property provides a backdoor for mockito mocks to
  /// skip the verification that the class isn't implemented with `implements`.
  @visibleForTesting
  bool get isMock => false;

  /// Removes the value associated with the [key].
  Future<bool> remove(String key);

  /// Returns all key/value pairs persisted in this store.
  Future<Map<String, Object>> getAllFromDictionary(List<String> keys);

  // This method makes sure that NativeSharedPreferencesStorePlatform isn't implemented with `implements`.
  //
  // See class doc for more details on why implementing this class is forbidden.
  //
  // This private method is called by the instance setter, which fails if the class is
  // implemented with `implements`.
  void _verifyProvidesDefaultImplementations() {}
}

/// Stores data in memory.
///
/// Data does not persist across application restarts. This is useful in unit-tests.
class InMemoryNativeSharedPreferencesStore
    extends NativeSharedPreferencesStorePlatform {
  /// Instantiates an empty in-memory preferences store.
  InMemoryNativeSharedPreferencesStore.empty() : _data = <String, Object>{};

  /// Instantiates an in-memory preferences store containing a copy of [data].
  InMemoryNativeSharedPreferencesStore.withData(Map<String, Object> data)
      : _data = Map<String, Object>.from(data);

  final Map<String, Object> _data;

  @override
  Future<bool> clear() async {
    _data.clear();
    return true;
  }

  @override
  Future<Map<String, Object>> getAll() async {
    return Map<String, Object>.from(_data);
  }

  @override
  Future<Map<String, Object>> getAllFromDictionary(List<String> keys) async {
    return Map<String, Object>.from(_data);
  }

  @override
  Future<bool> remove(String key) async {
    _data.remove(key);
    return true;
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    _data[key] = value;
    return true;
  }
}
