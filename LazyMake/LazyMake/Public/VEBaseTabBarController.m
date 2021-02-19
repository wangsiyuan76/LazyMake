//
//  VEBaseTabBarController.m
//  LazyMake
//
//  Created by xunruiIOS on 2020/3/31.
//  Copyright © 2020 xunruiIos. All rights reserved.
//

#import "VEBaseTabBarController.h"
#import "VEHomeMainController.h"
#import "VEFindMainController.h"
#import "VEUserCenterController.h"

@interface VEBaseTabBarController () <UITabBarControllerDelegate>

@end

@implementation VEBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[UITabBar appearance]setTintColor:MAIN_NAV_COLOR];
//    [[UITabBar appearance]setUnselectedItemTintColor:[UIColor colorWithHexString:@"A1A7B2"]];
    [UITabBar appearance].translucent = NO;
    [[UITabBar appearance]setBarTintColor:MAIN_NAV_COLOR];
    self.delegate = self;
    
    //首页
    VEHomeMainController * homeVC = [[VEHomeMainController alloc ] init ];
    UINavigationController *navHomeVC = [[UINavigationController alloc]initWithRootViewController:homeVC];
    homeVC.tabBarItem.title = @"首页";
    homeVC.tabBarItem.image = [[UIImage imageNamed:@"vm_home_tab_1_n"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"vm_home_tab_1_p"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [homeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"A1A7B2"],
                                               NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateNormal];
    [homeVC.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"1DABFD"],
                                               NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateSelected];
    homeVC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
   
    //发现页
    VEFindMainController * discover = [[VEFindMainController alloc ] init ];
    UINavigationController *navDiscover = [[UINavigationController alloc]initWithRootViewController:discover];
    discover.tabBarItem.title = @"发现";
    discover.tabBarItem.image = [[UIImage imageNamed:@"vm_home_tab_2_n"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discover.tabBarItem.selectedImage = [[UIImage imageNamed:@"vm_home_tab_2_p"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [discover.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"A1A7B2"],
                                               NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateNormal];
    [discover.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"1DABFD"],
                                               NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateSelected];
    discover.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);

    //个人中心
    VEUserCenterController * mine = [[VEUserCenterController alloc ] init ];
    UINavigationController *navMine = [[UINavigationController alloc]initWithRootViewController:mine];
    mine.tabBarItem.title = @"我的";
    mine.tabBarItem.image = [[UIImage imageNamed:@"vm_home_tab_3_n"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mine.tabBarItem.selectedImage = [[UIImage imageNamed:@"vm_home_tab_3_p"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [mine.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"A1A7B2"],
                                               NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateNormal];
    [mine.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHexString:@"1DABFD"],
                                               NSForegroundColorAttributeName,
                                               nil] forState:UIControlStateSelected];
    mine.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);

    self.viewControllers = @[navHomeVC,navDiscover,navMine];
    // Do any additional setup after loading the view.
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
