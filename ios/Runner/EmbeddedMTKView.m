//
//  EmbeddedMTKView.m
//  Runner
//
//  Created by zero on 2022/11/27.
//

#import "EmbeddedMTKView.h"

@implementation EmbeddedMTKView {
    // The command queue used to pass commands to the device.
    id<MTLCommandQueue> _commandQueue;
    CADisplayLink* _displayLink;
    CGFloat _tick;
}

- (instancetype _Nonnull)initWithViewId:(int64_t)viewId {
    if (self = [super init]) {
        self.paused = YES;
        self.enableSetNeedsDisplay = YES;
        
        self.device = MTLCreateSystemDefaultDevice();
        
        // Create the command queue
        _commandQueue = [self.device newCommandQueue];
        
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
        label.text = [NSString stringWithFormat:@"MTKView from IOS (id: %lld)", viewId];
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
    @autoreleasepool {
        // The render pass descriptor references the texture into which Metal should draw
        MTLRenderPassDescriptor *renderPassDescriptor = self.currentRenderPassDescriptor;
        if (renderPassDescriptor == nil)
        {
            return;
        }
        
        id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
        
        // Create a render pass and immediately end encoding, causing the drawable to be cleared
        id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        
        _tick = _tick + M_PI / 60;
        CGFloat green = (sin(_tick) + 1) / 2;
        self.clearColor = MTLClearColorMake(0.0, green, 0.0, 1.0);
        
        [commandEncoder endEncoding];
        
        // Get the drawable that will be presented at the end of the frame
        id<MTLDrawable> drawable = self.currentDrawable;
        
        // Request that the drawable texture be presented by the windowing system once drawing is done
        [commandBuffer presentDrawable:drawable];
        [commandBuffer commit];
    }
}

@end
