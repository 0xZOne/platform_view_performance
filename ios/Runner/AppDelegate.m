#import <Flutter/Flutter.h>
#import "AppDelegate.h"

#import "AAPLRenderer.h"
#import "EmbeddedUIView.h"
#import "FLNativeView.h"
#import "GeneratedPluginRegistrant.h"

@interface AppDelegate()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, AAPLRenderer *> *renders;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, EmbeddedUIView *> *views;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    FlutterViewController* controller = (FlutterViewController*)self.window.rootViewController;
    _renders = [[NSMutableDictionary alloc] init];
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                          methodChannelWithName:@"texture_controller"
                                          binaryMessenger:controller.binaryMessenger];

    [channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
    // This method is invoked on the UI thread.
    if ([@"create" isEqualToString:call.method]) {
        CGFloat width = [call.arguments[@"width"] floatValue];
        CGFloat height = [call.arguments[@"height"] floatValue];

        // just for test
        EmbeddedUIView *subview = [[EmbeddedUIView alloc ] initWithViewId:-99];
        [controller.view addSubview:subview];
        subview.frame = CGRectMake(0, 0, width, height);

        NSInteger __block textureId;
        id<FlutterTextureRegistry> __weak registry = controller;
        AAPLRenderer* render = [[AAPLRenderer alloc] initWithSize:CGSizeMake(width, height)
                                                         rootView:subview
                                                        onNewFrame:^{
                                                            [registry textureFrameAvailable:textureId];
                                                        }];

        textureId = [controller registerTexture:render];
        self.renders[@(textureId)] = render;
        self.views[@(textureId)] = subview;
        result(@(textureId));
    } else if ([@"dispose" isEqualToString:call.method]) {
        NSNumber *textureId = call.arguments[@"textureId"];
        
        EmbeddedUIView *subview = self.views[textureId];
        [subview removeFromSuperview];
        [self.views removeObjectForKey:textureId];
        
        AAPLRenderer *render = self.renders[textureId];
        [render dispose];
        [self.renders removeObjectForKey:textureId];
        
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
  }];

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
