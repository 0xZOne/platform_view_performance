//
//  EmbeddedView.m
//  Runner
//
//  Created by zero on 2022/12/14.
//

#import "EmbeddedView.h"

@implementation EmbeddedView {
  UILabel *_label;
}

- (instancetype)initWithViewId:(int64_t)viewId {
  if (self = [super init]) {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 200, 40)];
    _label.text = [NSString stringWithFormat:@"UIView From IOS (id: %lld)", viewId];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.adjustsFontSizeToFitWidth = YES;
    _label.textColor = [UIColor whiteColor];

    self.backgroundColor = [UIColor greenColor];
    [self addSubview:_label];
  }

  return self;
}
@end

