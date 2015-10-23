//
//  JDUserCenterViewController.m
//  Demo
//
//  Created by he15his on 15/10/23.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDUserCenterViewController.h"
#import <AVOSCloudSNS.h>
#import "JDNotificationKeyConstan.h"

@interface JDUserCenterViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation JDUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotification:) name:kNotificationKey_LoginSuccess object:nil];
    [self setUserNickName];
}

- (void)loginSuccessNotification:(NSNotification *)notification {
    [self setUserNickName];
}

#pragma mark - Event Handle
- (IBAction)logoutButtonClicked:(UIButton *)sender {
    if ([AVOSCloudSNS userInfo:AVOSCloudSNSQQ]) {
        [AVOSCloudSNS logout:AVOSCloudSNSQQ];
    }else if ([AVOSCloudSNS userInfo:AVOSCloudSNSWeiXin]) {
        [AVOSCloudSNS logout:AVOSCloudSNSWeiXin];
    }
    
    self.tabBarController.selectedIndex = 0;
}

#pragma mark - Private Method

- (void)setUserNickName {
    if ([AVOSCloudSNS userInfo:AVOSCloudSNSQQ]) {
        //登录了qq
        NSDictionary *userDic = [AVOSCloudSNS userInfo:AVOSCloudSNSQQ];
        self.descriptionLabel.text = [NSString stringWithFormat:@"登录了QQ帐号:%@", userDic[@"username"]];
    }else if ([AVOSCloudSNS userInfo:AVOSCloudSNSWeiXin]) {
        //登录了微信
        NSDictionary *userDic = [AVOSCloudSNS userInfo:AVOSCloudSNSWeiXin];
        self.descriptionLabel.text = [NSString stringWithFormat:@"登录了微信帐号:%@", userDic[@"username"]];
    }else {
        //未登录
    }
}
@end
