//
//  UIView+ToTexture.m
//  Runner
//
//  Created by zero on 2022/11/29.
//

#import "UIView+ToTexture.h"

@implementation UIView (ToTexture)
- (id<MTLTexture> _Nullable) renderToTexture:(id<MTLDevice> _Nonnull) device
                                   iosurface:(IOSurfaceRef _Nonnull) iosurface {
    int width = self.bounds.size.width;
    int height = self.bounds.size.height;

    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             width,
                                             height,
                                             8, // bitsPerComponent
                                             0, // bytesPerRow
                                             CGColorSpaceCreateDeviceRGB(), // colorspace
                                             kCGImageAlphaPremultipliedLast); // bitmapInfo
    CGContextConcatCTM(ctx, CGAffineTransformMakeRotation(0));
    CGAffineTransform flipVertical = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, height);
    CGContextConcatCTM(ctx, flipVertical);

//    CGAffineTransform flipHorizontal = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, width, 0.0);
//    CGContextConcatCTM(ctx, flipHorizontal);

    [self.layer renderInContext:ctx];

    // create Texturedescriptor (blueprint for texture)
    MTLTextureDescriptor *mtlTextDesc =
    [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:MTLPixelFormatRGBA8Unorm
                                                       width:width
                                                      height:height
                                                   mipmapped:NO];
    mtlTextDesc.usage = MTLTextureUsageRenderTarget | MTLTextureUsageShaderRead;

    // create texture with "blueprint"
    id<MTLTexture> texture = [device newTextureWithDescriptor:mtlTextDesc
                                                    iosurface:iosurface
                                                        plane:0];

    MTLRegion region = MTLRegionMake2D(0, 0, width, height);
    size_t bytesPerRow = CGBitmapContextGetBytesPerRow(ctx);
    void* data = CGBitmapContextGetData(ctx);
    [texture replaceRegion:region
               mipmapLevel:0
                 withBytes:data
               bytesPerRow:bytesPerRow];

    return texture;
}

- (CVPixelBufferRef)renderToCVPixelBuffer {
    NSDictionary *options = @{
        (NSString*)kCVPixelBufferCGImageCompatibilityKey : @YES,
        (NSString*)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
        (NSString*)kCVPixelBufferIOSurfacePropertiesKey : [NSDictionary dictionary]
    };

    CVPixelBufferRef pixelBuffer = NULL;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CVReturn cvValue = CVPixelBufferCreate(kCFAllocatorDefault,
                                           width,
                                           height,
                                           kCVPixelFormatType_32ARGB,
                                           (__bridge CFDictionaryRef)options,
                                           &pixelBuffer);
    NSAssert(cvValue == kCVReturnSuccess && pixelBuffer != NULL, @"Failed to create pixel buffer.");

    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    void* pixelData = CVPixelBufferGetBaseAddress(pixelBuffer);
    NSParameterAssert(pixelData != NULL);

    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer);
    CGContextRef ctx = CGBitmapContextCreate(pixelData,
                                             width,
                                             height,
                                             8, // bitsPerComponent
                                             bytesPerRow, // bytesPerRow
                                             colorspace, // colorspace
                                             kCGImageAlphaPremultipliedFirst); // bitmapInfo
    NSParameterAssert(ctx);
    CGContextConcatCTM(ctx, CGAffineTransformMakeRotation(0));
    CGAffineTransform flipVertical = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, height);
    CGContextConcatCTM(ctx, flipVertical);

    [self.layer renderInContext:ctx];

    CGColorSpaceRelease(colorspace);
    CGContextRelease(ctx);
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);

    return pixelBuffer;
}
@end

