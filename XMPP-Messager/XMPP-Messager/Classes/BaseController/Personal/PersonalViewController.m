//
//  PersonalViewController.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "PersonalViewController.h"
#import "LoginViewController.h"


@interface PersonalViewController ()

// 点击手势
@property (weak, nonatomic) UITapGestureRecognizer *tap;

@property (weak, nonatomic) IBOutlet UIView *userInfo;

@property (weak, nonatomic) IBOutlet UILabel *userSignature;

@property (weak, nonatomic) IBOutlet UIButton *userQrcode;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *bottomButtonSetting;

@property (weak, nonatomic) IBOutlet UIButton *bottomButtonNight;

@property (weak, nonatomic) IBOutlet UIButton *bottomButtonWeather;

@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self _initUI];
    
    [self _loadTapGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)_initUI{
    
//    self.view.backgroundColor = COLOR_TINT;
    
    
}

- (void)_loadTapGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userLogin:)];
    self.tap = tap;
    [self.userInfo addGestureRecognizer:self.tap];
    
}

- (void)userLogin:(UITapGestureRecognizer *)tap{
    CGPoint location = [tap locationInView:self.view];
    if (CGRectContainsPoint(self.userInfo.frame, location)) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_XMPP object:NOTI_XMPP_DISCONNECT];
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
            
            
        }];
        
        
        
    }
    
    
}



@end
