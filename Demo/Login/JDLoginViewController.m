//
//  JDLoginViewController.m
//  Demo
//
//  Created by he15his on 15/10/22.
//  Copyright © 2015年 he15his. All rights reserved.
//

#import "JDLoginViewController.h"
#import <AVOSCloudSNS.h>
#import <SVProgressHUD.h>
#import "JDNotificationKeyConstan.h"

@interface JDLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *wechatLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *qqLoginButton;

@end

@implementation JDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wechatLoginButton.layer.borderWidth = 1.;
    self.wechatLoginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.qqLoginButton.layer.borderWidth = 1.;
    self.qqLoginButton.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark - Event Handle

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)wechatLogin:(id)sender {
    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSWeiXin]) {
        // 请到真机测试
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            //        {
            //            "access_token" = "OezXcEiiBSKSxW0eoylIeN_WWsgxroiydYCNnIX5hyDjK3CwA1hc2bvS1oaaaYqwpP7_vb7nhWadkCXGQukQ0hVjCPvWDHjGqSAF0utf2xvXG5coBh2RZViBKxd0POkMDYu0vNLQoBOTfl9yDzzLJQ";
            //            avatar = "http://wx.qlogo.cn/mmopen/3Qx7ibib84ibZMVgJAaEAN7HW8Kyc3s0hLTKcuSlzSJibG8Mbr4g3PsApj8G1u5XxLq9Dnp7XiafxL9h4RSCUIbX39l6lc90Kyzcx/0";
            //            "expires_at" = "2015-07-30 08:38:24 +0000";
            //            id = oazTlwQwmWLyzz7wxnAXDsSZUjcM;
            //            platform = 3;
            //            "raw-user" =     {
            //                city = "";
            //                country = CN;
            //                headimgurl = "http://wx.qlogo.cn/mmopen/3Qx7ibib84ibZMVgJAaEAN7HW8Kyc3s0hLTKcuSlzSJibG8Mbr4g3PsApj8G1u5XxLq9Dnp7XiafxL9h4RSCUIbX39l6lc90Kyzcx/0";
            //                language = "zh_CN";
            //                nickname = "\U674e\U667a\U7ef4";
            //                openid = oazTlwQwmWLyzz7wxnAXDsSZUjcM;
            //                privilege =         (
            //                );
            //                province = Beijing;
            //                sex = 1;
            //                unionid = ox7NLs813rA9sP6QPbadkulxgHn8;
            //            };
            //            username = "\U674e\U667a\U7ef4";
            //        }
            
            NSLog(@"object : %@ error:%@", object, error);
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.description];
            }else {
//                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"登录成功，用户:%@", object[@"username"]]];
                [self dismiss:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKey_LoginSuccess object:nil];
            }
        } toPlatform:AVOSCloudSNSWeiXin];
    } else {
        [SVProgressHUD showErrorWithStatus:@"没有安装微信，暂不能登录"];
    }
}

- (IBAction)qqLogin:(id)sender {

    if ([AVOSCloudSNS isAppInstalledForType:AVOSCloudSNSQQ]) {
        [AVOSCloudSNS loginWithCallback:^(id object, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:error.description];
            } else {
//                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"登录成功，用户:%@", object[@"username"]]];
                [self dismiss:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationKey_LoginSuccess object:nil];
            }
        } toPlatform:AVOSCloudSNSQQ];
    }else {
        [SVProgressHUD showErrorWithStatus:@"没有安装QQ，暂不能登录"];
    }
}
@end
