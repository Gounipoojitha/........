#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <FirebaseCore/FirebaseCore.h>  // Added import for Firebase

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FIRApp configure];  // Added Firebase initialization
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end