#import "EmbeddedUIView.h"
#import "EmbeddedMTKView.h"
#import "FLNativeView.h"

@implementation FLNativeViewFactory {
  NSObject<FlutterBinaryMessenger>* _messenger;
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  self = [super init];
  if (self) {
    _messenger = messenger;
  }
  return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
  return [[FLNativeView alloc] initWithFrame:frame
                              viewIdentifier:viewId
                                   arguments:args
                             binaryMessenger:_messenger];
}

@end

@implementation FLNativeView {
   UIView *_view;
}

- (double)displayRefreshRate {
  CADisplayLink* display_link = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
  display_link.paused = YES;
  double preferredFPS = display_link.preferredFramesPerSecond;

  // From Docs:
  // The default value for preferredFramesPerSecond is 0. When this value is 0, the preferred
  // frame rate is equal to the maximum refresh rate of the display, as indicated by the
  // maximumFramesPerSecond property.
 if (preferredFPS != 0) {
    return preferredFPS;
 }

 return [UIScreen mainScreen].maximumFramesPerSecond;
}

- (void)onDisplayLink:(CADisplayLink*)link {
  // no-op.
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
  if (self = [super init]) {
      _view = [[EmbeddedUIView alloc] initWithViewId:viewId];
//      _view = [[EmbeddedMTKView alloc] initWithViewId:viewId];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 300, 40)];
    label.text = [NSString stringWithFormat:@"PlatformView (id: %lld, preferredFPS: %f)", viewId, [self displayRefreshRate]];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor whiteColor];
    [_view addSubview:label];
  }

  return self;
}

- (UIView*)view {
  return _view;
}

@end
