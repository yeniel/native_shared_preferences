# Migration Shared Preferences
===========

[![Codemagic build status](https://api.codemagic.io/apps/5e725e3a4ee7f400125dc26f/5e725e3a4ee7f400125dc26e/status_badge.svg)](https://codemagic.io/apps/5e725e3a4ee7f400125dc26f/5e725e3a4ee7f400125dc26e/latest_build)

This plugin is a copy of the shared_preferences package but without the prefix in the keys. Is used to migrate the data from previous native app.

The issue is that flutter add a prefix to the keys when read and write. So we can not read our old keys.
Also for Android you can now specify name of your resource file in `android/app/src/main/res/values/strings.xml`:

```
<resources>
    ...
    <string name="flutter_shared_pref_name">resource_name</string>
    ...
</resources>

```

ISSUE
https://github.com/flutter/flutter/issues/52544

Only use this plugin when is needed get the shared preferences from previous native app version. For other situation use the official shared preferences package.

To manage the migration use this package https://pub.dev/packages/version_migration/


## Installation

Add in pubspec:

```
native_shared_preferences: ^2.0.10
```

## Usage
To use this plugin, add `native_shared_preferences` in your pubspec.yaml file

### Example

``` dart
import 'package:flutter/material.dart';
import 'package:native_shared_preferences/native_shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
      child: RaisedButton(
        onPressed: _incrementCounter,
        child: Text('Increment Counter'),
        ),
      ),
    ),
  ));
}

_incrementCounter() async {
  NativeSharedPreferences prefs = await NativeSharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  print('Pressed $counter times.');
  await prefs.setInt('counter', counter);
}
```

### Testing

You can populate `NativeSharedPreferences` with initial values in your tests by running this code:

```dart
NativeSharedPreferences.setMockInitialValues (Map<String, dynamic> values);
```