//
//  JXSubscrollView.h
//  FloatingTableHeaderView
//
//  Created by wjx on 2021/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXSubscrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame
                      builder:(void (^)(JXSubscrollView *scrollView))builder;

@end

NS_ASSUME_NONNULL_END
