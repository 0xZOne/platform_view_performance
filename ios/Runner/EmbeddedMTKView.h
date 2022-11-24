//
//  EmbeddedMTKView.h
//  Runner
//
//  Created by zero on 2022/11/27.
//

#ifndef EmbeddedMTKView_h
#define EmbeddedMTKView_h

@import MetalKit;

// A UIView that is used as the embedded UIViews.
@interface EmbeddedMTKView : MTKView
- (instancetype _Nonnull)initWithViewId:(int64_t)viewId;

@end
#endif /* EmbeddedMTKView_h */
