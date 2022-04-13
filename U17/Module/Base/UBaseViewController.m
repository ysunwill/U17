//
//  UBaseViewController.m
//  U17
//
//  Created by ysunwill on 2022/3/4.
//

#import "UBaseViewController.h"

@interface UBaseViewController ()

@end

@implementation UBaseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fixScrollInsets];
    [self setupViews];
    [self loadData];
}

#pragma mark - Private Methods

- (void)fixScrollInsets
{
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupViews
{
    
}

- (void)loadData
{
    
}


@end
