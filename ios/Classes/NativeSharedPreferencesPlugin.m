#import "NativeSharedPreferencesPlugin.h"

@implementation NativeSharedPreferencesPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel methodChannelWithName:@"native_shared_preferences"
                                                              binaryMessenger:registrar.messenger];
  [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
    NSString *method = [call method];
    NSDictionary *arguments = [call arguments];

    if ([method isEqualToString:@"getAll"]) {
      result([self getAllPrefs]);
    } else if ([method isEqualToString:@"setBool"]) {
      NSString *key = arguments[@"key"];
      NSNumber *value = arguments[@"value"];
      [[[NSUserDefaults alloc] initWithSuiteName:@"com.dontpanicdevs.DontPanic"] setBool:value.boolValue forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setInt"]) {
      NSString *key = arguments[@"key"];
      NSNumber *value = arguments[@"value"];
      // int type in Dart can come to native side in a variety of forms
      // It is best to store it as is and send it back when needed.
      // Platform channel will handle the conversion.
      [[[NSUserDefaults alloc] initWithSuiteName:@"com.dontpanicdevs.DontPanic"] setValue:value forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setDouble"]) {
      NSString *key = arguments[@"key"];
      NSNumber *value = arguments[@"value"];
      [[[NSUserDefaults alloc] initWithSuiteName:@"com.dontpanicdevs.DontPanic"] setDouble:value.doubleValue forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setString"]) {
      NSString *key = arguments[@"key"];
      NSString *value = arguments[@"value"];
      [[[NSUserDefaults alloc] initWithSuiteName:@"com.dontpanicdevs.DontPanic"] setValue:value forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"setStringList"]) {
      NSString *key = arguments[@"key"];
      NSArray *value = arguments[@"value"];
      [[[NSUserDefaults alloc] initWithSuiteName:@"com.dontpanicdevs.DontPanic"] setValue:value forKey:key];
      result(@YES);
    } else if ([method isEqualToString:@"commit"]) {
      // synchronize is deprecated.
      // "this method is unnecessary and shouldn't be used."
      result(@YES);
    } else if ([method isEqualToString:@"remove"]) {
      [[[NSUserDefaults alloc] initWithSuiteName:@"com.dontpanicdevs.DontPanic"] removeObjectForKey:arguments[@"key"]];
      result(@YES);
    } else if ([method isEqualToString:@"clear"]) {
      NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"com.dontpanicdevs.DontPanic"];
      for (NSString *key in [self getAllPrefs]) {
        [defaults removeObjectForKey:key];
      }
      result(@YES);
    } else {
      result(FlutterMethodNotImplemented);
    }
  }];
}

#pragma mark - Private

+ (NSMutableDictionary *)getAllPrefs {
  NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
  NSDictionary *prefs = [[[NSUserDefaults alloc] initWithSuiteName:@"com.dontpanicdevs.DontPanic"] dictionaryRepresentation];
  NSMutableDictionary *filteredPrefs = [NSMutableDictionary dictionary];
  if (prefs != nil) {
    NSMutableDictionary *mappedDictionary = [NSMutableDictionary dictionary];
    
    [self mapDateToMilliseconds:prefs mappedDictionary:mappedDictionary];
      
    for (NSString *candidateKey in mappedDictionary) {
        [filteredPrefs setObject:mappedDictionary[candidateKey] forKey:candidateKey];
    }
  }
  return filteredPrefs;
}

+(void)mapDateToMilliseconds:(NSDictionary *)dictionary mappedDictionary:(NSMutableDictionary *)mappedDictionary {
    for (NSString* key in [dictionary allKeys]) {
        id value = [dictionary objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary *newDictionary = (NSDictionary *)value;
            NSMutableDictionary *newMappedDictionary = [NSMutableDictionary dictionary];
            
            [self mapDateToMilliseconds:newDictionary mappedDictionary:newMappedDictionary];
            mappedDictionary[key] = newMappedDictionary;
        } else if ([value isKindOfClass:[NSArray class]]) {
            NSMutableArray *newArray = [[NSMutableArray alloc] init];
            
            for (id element in ((NSArray *)value)) {
                if ([element isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *newMappedDictionary = [NSMutableDictionary dictionary];
                    
                    [self mapDateToMilliseconds:(NSDictionary *)element mappedDictionary:newMappedDictionary];
                    [newArray addObject:newMappedDictionary];
                } else {
                    [newArray addObject:element];
                }
            }
            
            mappedDictionary[key] = newArray;
        } else if ([value isKindOfClass:[NSDate class]]) {
            mappedDictionary[key] = [NSNumber numberWithDouble:floor([((NSDate *)value) timeIntervalSince1970] * 1000)];
        } else {
            mappedDictionary[key] = value;
        }
    }
}

@end
