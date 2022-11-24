/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implementation for a renderer class that performs Metal setup and
 per-frame rendering.
*/

@import MetalKit;

#import "AAPLRenderer.h"
#import "UIView+ToTexture.h"


// The main class performing the rendering.
@implementation AAPLRenderer
{
    id<MTLDevice> _device;
    IOSurfaceRef _ioSurface;
    CADisplayLink* _displayLink;
    void(^_onNewFrame)(void);
    CGSize _renderSize;
    CGFloat _tick;
    UIView* _view;
}

- (void)recreateIOSurfaceWithSize:(CGSize)size {
  if (_ioSurface) {
    CFRelease(_ioSurface);
  }

  unsigned pixelFormat = 'BGRA';
  unsigned bytesPerElement = 4;

  size_t bytesPerRow = IOSurfaceAlignProperty(kIOSurfaceBytesPerRow, size.width * bytesPerElement);
  size_t totalBytes = IOSurfaceAlignProperty(kIOSurfaceAllocSize, size.height * bytesPerRow);
  NSDictionary* options = @{
    (id)kIOSurfaceWidth : @(size.width),
    (id)kIOSurfaceHeight : @(size.height),
    (id)kIOSurfacePixelFormat : @(pixelFormat),
    (id)kIOSurfaceBytesPerElement : @(bytesPerElement),
    (id)kIOSurfaceBytesPerRow : @(bytesPerRow),
    (id)kIOSurfaceAllocSize : @(totalBytes),
  };

  _ioSurface = IOSurfaceCreate((CFDictionaryRef)options);
  IOSurfaceSetValue(_ioSurface, CFSTR("IOSurfaceColorSpace"), kCGColorSpaceSRGB);
}

/// Initializes the renderer with the MetalKit view from which you obtain the Metal device.
- (nonnull instancetype)initWithSize:(CGSize)renderSize
                            rootView:(UIView *_Nonnull)view
                          onNewFrame:(void(^_Nonnull)(void))onNewFrame {
    self = [super init];
    if(self)
    {
        _renderSize = renderSize;
        _onNewFrame = onNewFrame;
        _view = view;

        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

        // 1. Creating an MTLDevice
        _device = MTLCreateSystemDefaultDevice();

        // 2. Creating a IOSurface
        [self recreateIOSurfaceWithSize: _renderSize];
    }
    return self;
}

// Handles view rendering for a new frame.
- (void)onDisplayLink {
    [_view renderToTexture: _device
                 iosurface:_ioSurface];
}

- (CVPixelBufferRef)pixelBuffer {
    CVPixelBufferRef pixelBuffer = NULL;
    CVReturn cvValue =
      CVPixelBufferCreateWithIOSurface(kCFAllocatorDefault, _ioSurface, NULL, &pixelBuffer);
    NSAssert(cvValue == kCVReturnSuccess && pixelBuffer != NULL, @"Failed to create pixel buffer.");
    return pixelBuffer;
}

- (void)dispose {
    _device = nil;
    if (_ioSurface) {
        CFRelease(_ioSurface);
    }
    _ioSurface = nil;
}

#pragma mark - FlutterTexture

- (CVPixelBufferRef _Nullable)copyPixelBuffer {
    return [self pixelBuffer];
}

@end
