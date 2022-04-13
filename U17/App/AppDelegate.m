//
//  AppDelegate.m
//  U17
//
//  Created by ysunwill on 2022/2/25.
//

#import "AppDelegate.h"
#import "UTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UTabBarController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - Private Functions




@end
