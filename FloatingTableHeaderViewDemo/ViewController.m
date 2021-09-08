//
//  ViewController.m
//  FloatingTableHeaderViewDemo
//
//  Created by wjx on 2021/9/8.
//

#import "ViewController.h"
#import "JXScrollView.h"
#import "JXSubscrollView.h"

static inline CGFloat _tableHeaderViewHeight(void)
{
    return 200;
}

static inline CGRect frameYOfStatusBar(void)
{
    if (@available(iOS 13.0, *)) {
        UIWindow *window = [UIApplication.sharedApplication.windows filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIWindow * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return evaluatedObject.isKeyWindow;
        }]].firstObject;
        return window.windowScene.statusBarManager.statusBarFrame;
    } else {
        return UIApplication.sharedApplication.statusBarFrame;
    }
}


@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) JXScrollViewContext *context;
@property (nonatomic, strong) JXScrollView *scrollView;
@end

@implementation ViewController

- (void)loadView
{
    JXScrollViewContext *context = [[JXScrollViewContext alloc] init];
    context.subscrollViewClasses = @[JXSubscrollView.class];
    context.maxScrollHeight = _tableHeaderViewHeight();
    context.canMoveScrollView = YES; // 最初时是可以滑动的
    self.context = context;

    JXScrollView *scrollView = [[JXScrollView alloc] initWithFrame:(CGRect) {
        .size.width = UIScreen.mainScreen.bounds.size.width,
        .size.height = UIScreen.mainScreen.bounds.size.height - CGRectGetMaxY(frameYOfStatusBar()) - self.navigationController.navigationBar.frame.size.height
    } context:_context];
    scrollView.backgroundColor = UIColor.lightGrayColor;
    scrollView.contentSize = (CGSize) {
        .width = scrollView.bounds.size.width,
        .height = scrollView.bounds.size.height + _tableHeaderViewHeight()
    };
    scrollView.delegate = self;
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.scrollView = scrollView;
    self.view = scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"嵌套 tableView 并吸顶";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:(CGRect) {
        .size.width = UIScreen.mainScreen.bounds.size.width,
        .size.height = _tableHeaderViewHeight()
    }];
    headerLabel.backgroundColor = [UIColor.blueColor colorWithAlphaComponent:.4];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.font = [UIFont systemFontOfSize:40];
    headerLabel.textColor = UIColor.blackColor;
    headerLabel.text = @"Header will hide";
    [self.view addSubview:headerLabel];
    
    JXSubscrollView *subscrollView = [[JXSubscrollView alloc] initWithFrame:(CGRect) {
        .origin.y = CGRectGetMaxY(headerLabel.frame),
        .size.width = UIScreen.mainScreen.bounds.size.width,
        .size.height = _scrollView.bounds.size.height
    } builder:^(JXSubscrollView * _Nonnull scrollView) {
        scrollView.backgroundColor = UIColor.orangeColor;
        scrollView.pagingEnabled = YES;
        
        const CGFloat tabCount = 2;
        scrollView.contentSize = (CGSize) {
            .width = tabCount * UIScreen.mainScreen.bounds.size.width,
            .height = scrollView.bounds.size.height
        };
        
        CGFloat width = UIScreen.mainScreen.bounds.size.width;
        CGFloat x = .0;
        for (int i = 0; i < tabCount; x += width, ++i) {
            UILabel *label = [[UILabel alloc] initWithFrame:(CGRect) {
                .origin.x = x,
                .size.width = width,
                .size.height = 40
            }];
            label.backgroundColor = UIColor.purpleColor;
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = UIColor.blackColor;
            label.font = [UIFont systemFontOfSize:30];
            label.text = [NSString stringWithFormat:@"Floating@Top Header %d", i];
            [scrollView addSubview:label];
            
            UITableView *tableView = [[UITableView alloc] initWithFrame:(CGRect) {
                .origin.x = x,
                .origin.y = CGRectGetMaxY(label.frame),
                .size.width = width,
                .size.height = scrollView.bounds.size.height - CGRectGetHeight(label.frame)
            } style:UITableViewStylePlain];
            tableView.backgroundColor = UIColor.blueColor;
            tableView.showsHorizontalScrollIndicator = NO;
            tableView.showsVerticalScrollIndicator = NO;
            [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:NSStringFromClass(UITableViewCell.class)];
            tableView.dataSource = self;
            tableView.delegate = self;
            [scrollView addSubview:tableView];
        }
    }];
    [self.view addSubview:subscrollView];
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(UITableViewCell.class)];
    cell.textLabel.text = [NSString stringWithFormat:@"row %ld", (long)indexPath.row];
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"tableView: %@, didSelect: %@", tableView, indexPath);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView == _scrollView) {
        if (nil != _context) {
            if (scrollView.contentOffset.y >= _context.maxScrollHeight) {
                _context.canMoveScrollView = NO;
                _context.canMoveSubscrollView = YES;
            }
            
            if (!_context.canMoveScrollView) {
                scrollView.contentOffset = (CGPoint) {
                    .y = _context.maxScrollHeight
                };
            }
        }
    } else if ([scrollView isKindOfClass:UITableView.class]) {
        if (!_context.canMoveSubscrollView) {
            scrollView.contentOffset = CGPointZero;
        }
        
        if (scrollView.contentOffset.y <= 0) {
            _context.canMoveScrollView = YES;
            _context.canMoveSubscrollView = NO;
        }
    }
}

@end
