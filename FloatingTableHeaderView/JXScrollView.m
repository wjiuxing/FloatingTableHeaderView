//
//  JXScrollView.m
//  FloatingTableHeaderView
//
//  Created by wjx on 2021/9/8.
//

#import "JXScrollView.h"

@implementation JXScrollViewContext

@end

@interface JXScrollView () <UIScrollViewDelegate>

@property (nonatomic, weak) JXScrollViewContext *context;

@end

@implementation JXScrollView

- (instancetype)initWithFrame:(CGRect)frame context:(JXScrollViewContext *)context;
{
    self = [super initWithFrame:frame];
    if (self) {
        _context = context;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    for (Class cls in _context.subscrollViewClasses) {
        if ([otherGestureRecognizer.view isKindOfClass:cls]) {
            return NO;
        }
    }
    
    return YES;
}

@end
