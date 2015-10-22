//
//  TabBarViewController.m
//  Demo
//
//  Created by he15his on 15/10/19.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDTabBarViewController.h"

@interface JDTabBarViewController ()

@end

@implementation JDTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self applyTheme];
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

@end
