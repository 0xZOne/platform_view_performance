//
//  UIView+ToTexture.h
//  Runner
//
//  Created by zero on 2022/11/29.
//

#import <UIKit/UIKit.h>
@import MetalKit;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ToTexture)
- (id<MTLTexture> _Nullable) renderToTexture:(id<MTLDevice> _Nonnull) device
                                   iosurface:(IOSurfaceRef _Nonnull) iosurface;

- (CVPixelBufferRef)renderToCVPixelBuffer;
@end

NS_ASSUME_NONNULL_END
