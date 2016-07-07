//
//  LoginViewController.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "LoginViewController.h"
#import "FriendViewController.h"
#import "XMPPManager.h"
#import <SCLAlertView.h>
@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginTapped:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"登录"]) {
        [[XMPPManager defaultManager] loginUsername:self.username.text password:self.password.text completion:^(BOOL ret) {
            if (ret) {
                // 登录成功
                NSString *jid = [self.username.text stringByAppendingString:XMPP_DOMAIN];
                [[NSUserDefaults standardUserDefaults] setObject:jid forKey:@"jid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else{
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                alert.showAnimationType = FadeIn;
                alert.hideAnimationType = FadeOut;
                alert.backgroundType = Blur;
                [alert showError:self title:@"连接失败" subTitle:nil closeButtonTitle:@"好的" duration:0.0f];
                
            }
            
        }];
    } else {
        
        [[XMPPManager defaultManager] signupUsername:self.username.text password:self.password.text completion:^(BOOL ret) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.showAnimationType = FadeIn;
            alert.hideAnimationType = FadeOut;
            alert.backgroundType = Blur;
            if (ret) {
                [alert showSuccess:self title:@"注册成功" subTitle:nil closeButtonTitle:@"好的" duration:0.0f];
            } else {
                [alert showError:self title:@"连接失败" subTitle:@"蓝牙灯连接失败!" closeButtonTitle:@"好的" duration:0.0f];    
            }
            
        }];
        
    }
    
    
    
}


- (IBAction)signupTapped:(UIButton *)sender {
    
    if (sender.tag) {
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [sender setTitle:@"新用户注册" forState:UIControlStateNormal];
    } else {
        [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        [sender setTitle:@"已有账号?点此登录" forState:UIControlStateNormal];
    }
    sender.tag = !sender.tag;
    
}






@end
