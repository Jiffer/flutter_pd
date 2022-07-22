#import "FlutterPdPlugin.h"
#if __has_include(<flutter_pd/flutter_pd-Swift.h>)
#import <flutter_pd/flutter_pd-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_pd-Swift.h"
#endif

@implementation FlutterPdPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPdPlugin registerWithRegistrar:registrar];
}
@end
