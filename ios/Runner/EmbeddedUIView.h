#include <UIKit/UIKit.h>

// A UIView that is used as the embedded UIViews.
@interface EmbeddedUIView : UIView
- (instancetype _Nonnull)initWithViewId:(int64_t)viewId;

@end
