//
//  TabBarViewController.m
//  Demo
//
//  Created by he15his on 15/10/19.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDTabBarViewController.h"
#import "JDLoginViewController.h"
#import "JDNewestTableViewController.h"
#import <MJRefresh.h>
#import <AVOSCloudSNS.h>
#import "JDNotificationKeyConstan.h"

@interface JDTabBarViewController ()<UITabBarControllerDelegate>

@end

@implementation JDTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotification:) name:kNotificationKey_LoginSuccess object:nil];

    [self applyTheme];
    self.delegate = self;
}

#pragma mark - Notification

- (void)loginSuccessNotification:(NSNotification *)notification {
    self.selectedIndex = 2;
}

#pragma mark - Private Method

- (void)applyTheme {
    UIColor *tintColor = [UIColor redColor];
    NSArray *tabBars = self.tabBar.items;
    NSArray *images = @[[UIImage imageNamed:@"tab_bar_1"],
                        [UIImage imageNamed:@"tab_bar_2"],
                        [UIImage imageNamed:@"tab_bar_3"]];
    NSArray *selectImages = @[[UIImage imageNamed:@"tab_bar_1_highlight"],
                              [UIImage imageNamed:@"tab_bar_2_highlight"],
                              [UIImage imageNamed:@"tab_bar_3_highlight"]];
    
    for (NSInteger i = 0; i < tabBars.count; i++) {
        UITabBarItem *item = tabBars[i];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} forState:UIControlStateNormal];
        [item setTitleTextAttributes: @{NSForegroundColorAttributeName : tintColor} forState: UIControlStateSelected];
        [self setupTabBarItem:item image:images[i] selectedImage:selectImages[i]];
    }
}


- (void)setupTabBarItem:(UITabBarItem *)item image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [item setImage:image];
    [item setSelectedImage: selectedImage];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UINavigationController *navCtl = (UINavigationController *)viewController;

    if (tabBarController.selectedViewController == viewController) {
        if ([navCtl.viewControllers[0] isKindOfClass:[JDNewestTableViewController class]]) {
            //刷新
            JDNewestTableViewController *newestCtl = (JDNewestTableViewController *)navCtl.viewControllers[0];
            [newestCtl.tableView.header beginRefreshing];
        }
        return NO;
    }
    
    if ([tabBarController.viewControllers indexOfObject:viewController] == 2) {
        if (![AVOSCloudSNS userInfo:AVOSCloudSNSQQ] && ![AVOSCloudSNS userInfo:AVOSCloudSNSWeiXin]) {
            //如果QQ和微信都没有登录就跳到登录页面
            [self performSegueWithIdentifier:@"TabBarCtlPresentloginCtl" sender:nil];
            return NO;
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}
@end
