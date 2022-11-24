#import "EmbeddedUIView.h"

@implementation EmbeddedUIView {
    CADisplayLink* _displayLink;
    CGFloat _tick;
}

- (instancetype)initWithViewId:(int64_t)viewId {
  if (self = [super init]) {
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
    label.text = [NSString stringWithFormat:@"UIView from IOS (id: %lld)", viewId];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
  }

  return self;
}

- (void)onDisplayLink {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    _tick = _tick + M_PI / 60;
    CGFloat green = (sin(_tick) + 1) / 2;

    [[UIColor colorWithRed:0.0
                     green:green
                      blue:0.0
                     alpha:1.0f] setFill];

    UIRectFill([self bounds]);
}

@end
