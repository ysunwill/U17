//
//  UTabBarController.m
//  U17
//
//  Created by ysunwill on 2022/3/2.
//

#import "UTabBarController.h"
#import "UNavigationController.h"
#import "UCommunityViewController.h"
#import "U17-Swift.h"

@interface UTabBarController ()

@end

@implementation UTabBarController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // opaque
    self.tabBar.translucent = NO;
    
    // community
    UCommunityViewController *communityVC = [UCommunityViewController new];
    UIImage *communityImage = [UIImage imageNamed:@"tab_community"];
    UIImage *selectedCommunityImage = [UIImage imageNamed:@"tab_community_selected"];
    [self addChildViewController:communityVC title:@"社区" image:communityImage selectedImage:selectedCommunityImage];
    
    // find, default
    FindViewController *findVC = [FindViewController new];
    UIImage *findImage = [UIImage imageNamed:@"tab_find"];
    UIImage *selectedFindImage = [UIImage imageNamed:@"tab_find_selected"];
    [self addChildViewController:findVC title:@"发现" image:findImage selectedImage:selectedFindImage];
    
    // default page
    self.selectedIndex = 1;
}

#pragma mark - Private Methods

- (void)addChildViewController:(UIViewController *)childVC title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
//    childVC.title = title;
    UITabBarItem *tab = [[UITabBarItem alloc] init];
    tab.image = image;
    tab.selectedImage = selectedImage;
    tab.imageInsets = UIEdgeInsetsMake(9, 0, -3, 0);
    UNavigationController *vc = [[UNavigationController alloc] initWithRootViewController:childVC];
    vc.tabBarItem = tab;
    [self addChildViewController:vc];

}

#pragma mark - Getter and Setter

@end
