//
//  JXScrollView.h
//  FloatingTableHeaderView
//
//  Created by wjx on 2021/9/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JXScrollViewContext : NSObject

@property (nonatomic, copy) NSArray *subscrollViewClasses;

@property (nonatomic, assign) BOOL canMoveScrollView;
@property (nonatomic, assign) BOOL canMoveSubscrollView;

@property (nonatomic, assign) CGFloat maxScrollHeight;

@end

@interface JXScrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame context:(JXScrollViewContext *)context;

@end

NS_ASSUME_NONNULL_END
