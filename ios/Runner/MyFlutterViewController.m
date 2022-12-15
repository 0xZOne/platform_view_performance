//
//  MyFlutterViewController.m
//  Runner
//
//  Created by zero on 2022/12/15.
//

#import "MyFlutterViewController.h"

@implementation MyFlutterViewController {
    CADisplayLink *_displayLink;
}

- (void)setup {
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(onDisplayLink:)];
        // Flutter引擎的VSYNC频率为120Hz，仅仅调整ViewController的帧率，借助Animation Hitches工具观察：
        // （测试机：iPhone 13 Pro Max，15.5）
        // 1. 设置60Hz时，存在肉眼可见的抖动
        // 2. 设置80Hz时，滑动非流畅，无任何肉眼可见的抖动
        // 3. 设置120Hz时，存在肉眼可见的轻微抖动
        //
        // （测试机：iPhone 13 Pro，16.0）
        // 1. 设置60/80/120Hz时，都存在肉眼可见的抖动，无显著差别
        //
        // 该处修改确实可以影响最终上屏的帧率
        double preferredFrameRate = 120.0;
        if (@available(iOS 15.0, *)) {
            _displayLink.preferredFrameRateRange = CAFrameRateRangeMake(preferredFrameRate, preferredFrameRate, preferredFrameRate);
        } else {
            _displayLink.preferredFramesPerSecond = preferredFrameRate;
        }

        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSRunLoopCommonModes];
    }
}

-(void) teardown {
    if (_displayLink != nil) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)onDisplayLink:(CADisplayLink *)displaylink {
    // Calculate the actual frame rate.
    // double actualFramesPerSecond = round(1 / (displaylink.targetTimestamp - displaylink.timestamp));
    // NSLog(@"Actual FPS: %f", actualFramesPerSecond);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [self setup];
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    _displayLink.paused = NO;
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    _displayLink.paused = YES;
    [super viewDidDisappear:animated];
}

- (void)dealloc {
    [self teardown];
}

@end
