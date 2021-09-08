//
//  JXSubscrollView.m
//  FloatingTableHeaderView
//
//  Created by wjx on 2021/9/8.
//

#import "JXSubscrollView.h"

@implementation JXSubscrollView

- (instancetype)initWithFrame:(CGRect)frame
                      builder:(void (^)(JXSubscrollView *scrollView))builder;
{
    self = [super initWithFrame:frame];
    if (self) {
        nil == builder ?: builder(self);
    }
    return self;
}

@end
