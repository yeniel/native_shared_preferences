#import "NativeSharedPreferencesPlugin.h"

@implementation NativeSharedPreferencesPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"native_shared_preferences"
                                                              binaryMessenger:registrar.messenger];
  [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
    NSString *method = [call method];
    NSDictionary *arguments = [call arguments];

    if ([method isEqualToString:@"getAll"]) {
      result(getAllPrefs());
    } else if ([method isEqualToString:@"setBool"]) {
      NSString *key = arguments[@"key"];
      NSNumber *value = arguments[@"value"];
      [[NSUserDefaults standardUserDefaults] setBool:value.boolValue forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setInt"]) {
      NSString *key = arguments[@"key"];
      NSNumber *value = arguments[@"value"];
      // int type in Dart can come to native side in a variety of forms
      // It is best to store it as is and send it back when needed.
      // Platform channel will handle the conversion.
      [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setDouble"]) {
      NSString *key = arguments[@"key"];
      NSNumber *value = arguments[@"value"];
      [[NSUserDefaults standardUserDefaults] setDouble:value.doubleValue forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setString"]) {
      NSString *key = arguments[@"key"];
      NSString *value = arguments[@"value"];
      [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setStringList"]) {
      NSString *key = arguments[@"key"];
      NSArray *value = arguments[@"value"];
      [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"commit"]) {
      // synchronize is deprecated.
      // "this method is unnecessary and shouldn't be used."
      result(@YES);
    } else if ([method isEqualToString:@"remove"]) {
      [[NSUserDefaults standardUserDefaults] removeObjectForKey:arguments[@"key"]];
      result(@YES);
    } else if ([method isEqualToString:@"clear"]) {
      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
      for (NSString *key in getAllPrefs()) {
        [defaults removeObjectForKey:key];
      }
      result(@YES);
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
}

#pragma mark - Private

static NSMutableDictionary *getAllPrefs() {
  NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
  NSDictionary *prefs = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
  NSMutableDictionary *filteredPrefs = [NSMutableDictionary dictionary];
  if (prefs != nil) {
    for (NSString *candidateKey in prefs) {
      [filteredPrefs setObject:prefs[candidateKey] forKey:candidateKey];
    }
  }
  return filteredPrefs;
}

@end
