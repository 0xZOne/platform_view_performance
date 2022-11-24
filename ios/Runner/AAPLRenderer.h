//
//  AAPLRenderer.h
//  Runner
//
//  Created by zero on 2022/11/24.
//

#ifndef AAPLRenderer_h
#define AAPLRenderer_h

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Header for a renderer class that performs Metal setup and per-frame rendering.
*/

// @import MetalKit;
#import <Flutter/Flutter.h>


// A platform-independent renderer class.
@interface AAPLRenderer : NSObject<FlutterTexture>

// - (nonnull instancetype)initWithMetalKitView:(nonnull MTKView *)mtkView;
- (nonnull instancetype)initWithSize:(CGSize)renderSize
                            rootView:(UIView *_Nonnull)view
                          onNewFrame:(void(^_Nonnull)(void))onNewFrame;

- (void)dispose;
@end


#endif /* AAPLRenderer_h */
