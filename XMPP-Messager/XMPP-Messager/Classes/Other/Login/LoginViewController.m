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

@property (weak, nonatomic) IBOutlet UIView *ejabberView;

@property (weak, nonatomic) IBOutlet UITextField *domain;
@property (weak, nonatomic) IBOutlet UITextField *host;


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
    
    [[NSUserDefaults standardUserDefaults] setObject:self.domain.text forKey:XMPP_DOMAIN];
    [[NSUserDefaults standardUserDefaults] setObject:self.host.text forKey:XMPP_HOSTNAME];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([sender.currentTitle isEqualToString:@"登录"]) {
        [[XMPPManager defaultManager] loginUsername:self.username.text password:self.password.text completion:^(BOOL ret) {
            if (ret) {
                // 登录成功
                NSString *jid = [self.username.text stringByAppendingString:XMPP_DOMAIN];
                [[NSUserDefaults standardUserDefaults] setObject:jid forKey:@"jid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else{
                
                // 注册失败时不保存
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:XMPP_DOMAIN];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:XMPP_HOSTNAME];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
        }];
    } else { // 注册
        
        
        
        [[XMPPManager defaultManager] signupUsername:self.username.text password:self.password.text completion:^(BOOL ret) {
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            alert.showAnimationType = FadeIn;
            alert.hideAnimationType = FadeOut;
            alert.backgroundType = Blur;
            if (ret) {
                [alert showSuccess:self title:@"注册成功" subTitle:nil closeButtonTitle:@"好的" duration:0.0f];
                
                // 保存
                
            } else {
                [alert showError:self title:@"连接失败" subTitle:@"蓝牙灯连接失败!" closeButtonTitle:@"好的" duration:0.0f];
                
                // 注册失败时不保存
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:XMPP_DOMAIN];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:XMPP_HOSTNAME];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
        }];
        
    }
    
    
    
}


- (IBAction)signupTapped:(UIButton *)sender {
    
    if (sender.tag) {
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [sender setTitle:@"新用户注册" forState:UIControlStateNormal];
        self.ejabberView.hidden = YES;
    } else {
        [self.loginBtn setTitle:@"注册" forState:UIControlStateNormal];
        [sender setTitle:@"已有账号?点此登录" forState:UIControlStateNormal];
        self.ejabberView.hidden = NO;
    }
    sender.tag = !sender.tag;
    
}

- (IBAction)close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
