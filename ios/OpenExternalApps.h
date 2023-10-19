
#ifdef RCT_NEW_ARCH_ENABLED
#import "RNOpenExternalAppsSpec.h"

@interface OpenExternalApps : NSObject <NativeOpenExternalAppsSpec>
#else
#import <React/RCTBridgeModule.h>

@interface OpenExternalApps : NSObject <RCTBridgeModule>
#endif

@end
