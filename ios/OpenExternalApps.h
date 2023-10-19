import <React/RCTBridgeModule.h>

@interface OpenExternalApps : NSObject <RCTBridgeModule>
- (void)openApp:(NSString *)bundleId
        resolver:(RCTPromiseResolveBlock)resolve
        rejecter:(RCTPromiseRejectBlock)reject;

- (void)openAppWithToken:(NSString *)bundleId
               tokenData:(NSString *)tokenData
                resolver:(RCTPromiseResolveBlock)resolve
                rejecter:(RCTPromiseRejectBlock)reject;

- (void)isAppInstalled:(NSString *)bundleId
              resolver:(RCTPromiseResolveBlock)resolve
              rejecter:(RCTPromiseRejectBlock)reject;
#endif

@end