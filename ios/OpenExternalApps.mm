#import "OpenExternalApps.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTUtils.h>
#import <UIKit/UIKit.h>

@implementation OpenExternalApps
RCT_EXPORT_MODULE()/
+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

RCT_EXPORT_METHOD(openApp:(NSString *)bundleId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", bundleId]];

  if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
    if (@available(iOS 10.0, *)) {
      [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:^(BOOL success) {
        if (success) {
          resolve(@"Success");
        } else {
          reject(@"AppNotOpened", @"Failed to open the app.", nil);
        }
      }];
    } else {
      BOOL success = [[UIApplication sharedApplication] openURL:appURL];
      if (success) {
        resolve(@"Success");
      } else {
        reject(@"AppNotOpened", @"Failed to open the app.", nil);
      }
    }
  } else {
    NSURL *marketURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/%@", bundleId]];

    if ([[UIApplication sharedApplication] canOpenURL:marketURL]) {
      reject(@"AppNotInstalled", [NSString stringWithFormat:@"The app with bundleId %@ is not installed, but it is available on the App Store.", bundleId], nil);
    } else {
      reject(@"AppNotFound", [NSString stringWithFormat:@"The app with bundleId %@ was not found.", bundleId], nil);
    }
  }
}

RCT_EXPORT_METHOD(openAppWithToken:(NSString *)bundleId
                  tokenData:(NSString *)tokenData
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", bundleId]];

  if ([[UIApplication sharedApplication] canOpenURL:appURL]) {
    NSDictionary *tokenDict = @{@"token": tokenData};
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:tokenDict options:0 error:&error];

    if (!error) {
      NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

      if ([appURL.scheme isEqualToString:@"http"] || [appURL.scheme isEqualToString:@"https"]) {
        reject(@"UnsupportedScheme", @"HTTP/HTTPS URLs are not supported for openAppWithToken.", nil);
      } else {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:jsonString forKey:@"token"];

        NSString *query = [RCTConvert NSString:params];

        if (query) {
          appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://%@", bundleId, query]];
        }

        if (@available(iOS 10.0, *)) {
          [[UIApplication sharedApplication] openURL:appURL options:@{} completionHandler:^(BOOL success) {
            if (success) {
              resolve(@"Success");
            } else {
              reject(@"AppNotOpened", @"Failed to open the app.", nil);
            }
          }];
        } else {
          BOOL success = [[UIApplication sharedApplication] openURL:appURL];
          if (success) {
            resolve(@"Success");
          } else {
            reject(@"AppNotOpened", @"Failed to open the app.", nil);
          }
        }
      }
    } else {
      reject(@"JSONError", @"Error parsing JSON", error);
    }
  } else {
    NSURL *marketURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/%@", bundleId]];

    if ([[UIApplication sharedApplication] canOpenURL:marketURL]) {
      reject(@"AppNotInstalled", [NSString stringWithFormat:@"The app with bundleId %@ is not installed, but it is available on the App Store.", bundleId], nil);
    } else {
      reject(@"AppNotFound", [NSString stringWithFormat:@"The app with bundleId %@ was not found.", bundleId], nil);
    }
  }
}

RCT_EXPORT_METHOD(isAppInstalled:(NSString *)bundleId
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)
{
  NSURL *appURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", bundleId]];
  BOOL isInstalled = [[UIApplication sharedApplication] canOpenURL:appURL];
  resolve(@(isInstalled));
}

@end
