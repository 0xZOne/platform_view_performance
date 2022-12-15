#import "AppDelegate.h"
#import "FLNativeView.h"
#import "GeneratedPluginRegistrant.h"
#import "MyFlutterViewController.h"

@implementation AppDelegate {
    FlutterViewController *flutterViewController;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  flutterViewController = [[MyFlutterViewController alloc] init];
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
  self.window.rootViewController = flutterViewController;
  [self.window makeKeyAndVisible];

  [GeneratedPluginRegistrant registerWithRegistry:self];

  // Register the platform view
  NSObject<FlutterPluginRegistrar>* registrar =
      [self registrarForPlugin:@"plugin-name"];
  FLNativeViewFactory* factory =
      [[FLNativeViewFactory alloc] initWithMessenger:registrar.messenger];
  [[self registrarForPlugin:@"<plugin-name>"] registerViewFactory:factory
                                                           withId:@"<simple-text-view>"];

  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
