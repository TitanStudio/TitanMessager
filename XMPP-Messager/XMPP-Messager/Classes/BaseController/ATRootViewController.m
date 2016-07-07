//
//  ATRootViewController.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATRootViewController.h"
#import "LoginViewController.h"

@interface ATRootViewController ()

@property (assign, nonatomic) BOOL isLeftViewOpen;

@property (weak, nonatomic) UIGestureRecognizer *pan;

@end

@implementation ATRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 把personal控制器作为子控制器
    [self addChildViewController:self.personalVC];
    // 重新修改frame
    self.personalVC.view.frame = CGRectMake(0, 0, SCREEN_W, SCREEN_H);
    // 把personal的视图添加到view
    [self.view addSubview:self.personalVC.view];
    
    // 添加tabbarVC
    [self addChildViewController:self.tabbarVC];
    // tabbarVC.view
    [self.view addSubview:self.tabbarVC.view];
    
    
    self.isLeftViewOpen = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftView:) name:NOTI_LEFTVIEW object:nil];
    
    
    [self performSelector:@selector(userLogin) withObject:nil afterDelay:0.5f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (PersonalViewController *)personalVC{
    
    if (!_personalVC) {
        _personalVC = [[PersonalViewController alloc] init];
    }
    return _personalVC;
    
}

- (BaseTabBarController *)tabbarVC{
    
    if (!_tabbarVC) {
        _tabbarVC = [[BaseTabBarController alloc] init];
    }
    return _tabbarVC;
}

- (void)leftView:(NSNotification *)noti{
    
    if ([noti.name isEqualToString:NOTI_LEFTVIEW]) {
        if ([noti.object isEqualToString:NOTI_LEFTVIEW_OPEN]) {
            [self openLeftView:YES];
        } else if ([noti.object isEqualToString:NOTI_LEFTVIEW_CLOSE]){
            [self openLeftView:NO];
        }
    }
    
}

- (void)openLeftView:(BOOL)yesOrNo{
    
    if (self.isLeftViewOpen ^ yesOrNo) {
        if (yesOrNo) {
            [UIView animateWithDuration:0.38f delay:0 options:UIViewAnimationOptionCurveEaseInOut  animations:^{
                self.tabbarVC.view.center = CGPointMake(SCREEN_W * 1.3, SCREEN_H * 0.5);
            } completion:^(BOOL finished) {
                self.isLeftViewOpen = YES;
            }];
        } else {
            [UIView animateWithDuration:0.38f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.tabbarVC.view.center = CGPointMake(SCREEN_W * 0.5, SCREEN_H * 0.5);
            } completion:^(BOOL finished) {
                self.isLeftViewOpen = NO;
            }];
        }
    }
    
}


- (void)userLogin{
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
        
        
        
    }];
    
}

@end
