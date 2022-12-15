//
//  EmbeddedView.m
//  Runner
//
//  Created by zero on 2022/12/14.
//

#import "EmbeddedView.h"

@implementation EmbeddedView {
  CADisplayLink* _displayLink;
  CGFloat _tick;
  int64_t _viewId;
  UILabel *_label;
  double _actual_refresh_rate;
}

- (instancetype)initWithViewId:(int64_t)viewId {
  if (self = [super init]) {
    _viewId = viewId;
    _displayLink = [CADisplayLink displayLinkWithTarget:self
                                               selector:@selector(onDisplayLink:)];
    // 借助Animation Hitches工具观察，Flutter引擎保持默认（120Hz）:
    // （测试手机：iPhone 13 Pro, 16.0)
    // 1. preferred帧率设置为60Hz(或者默认，不设置preferredFrameRateRange)，抖动最为严重，出现明显卡顿；
    // 2. preferred帧率设置为80Hz，有肉眼可见的抖动，比60Hz好很多；
    // 3. preferred帧率设置为120Hz，有不太容易觉察的轻微抖动，体感上比80Hz好；
    // 4. 此处的帧率修改，会实际影响最终的上屏帧率

    // （测试手机：iPhone 13 Pro Max，15.5）
    // 1. preferred帧率设置为60Hz(或者默认，不设置preferredFrameRateRange)，抖动最为严重，出现明显卡顿；
    // 2. preferred帧率设置为80Hz，多次测试没有任何抖动；
    // 3. preferred帧率设置为120Hz，有肉眼不太容易觉察的轻微抖动；
    // 4. 此处的帧率修改，会实际影响最终的上屏帧率
    double preferredFrameRate = 120.0;
    if (@available(iOS 15.0, *)) {
      _displayLink.preferredFrameRateRange = CAFrameRateRangeMake(preferredFrameRate, preferredFrameRate, preferredFrameRate);
    } else {
      _displayLink.preferredFramesPerSecond = preferredFrameRate;
    }
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSRunLoopCommonModes];

    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
    _label.text = [NSString stringWithFormat:@"UIView (id: %lld)", _viewId];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.adjustsFontSizeToFitWidth = YES;
    _label.textColor = [UIColor whiteColor];

    self.backgroundColor = [UIColor greenColor];
    [self addSubview:_label];
  }

  return self;
}

- (void)onDisplayLink:(CADisplayLink*)link {
  if (CACurrentMediaTime() >= link.targetTimestamp) {
    return;
  }

  _actual_refresh_rate = round(1/(link.targetTimestamp - link.timestamp));
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
  _label.text = [NSString stringWithFormat:@"UIView (id: %lld, Actual FPS: %f)", _viewId, _actual_refresh_rate];
}
@end

