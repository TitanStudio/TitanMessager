//
//  ATRootViewController.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ATRootViewController.h"
#import "MessageModel.h"
#import <SCLAlertView.h>
#import "UIViewController+ATScreenGesture.h"

// 侧滑打开之后的Center
#define SCREEN_CenterX_Opened (SCREEN_CenterX + SCREEN_W - at_rightMargin)

@interface ATRootViewController ()

@property (assign, nonatomic) BOOL isLeftViewOpen;

@property (weak, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation ATRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化控制器 : 主视图/左侧抽屉视图
    [self at_initWithMainVC:self.tabbarVC andleftVC:self.personalVC];
    
    // 设置app全局的主题色
    [self at_setAppThemeColor:nil];
    
    // 加载手势识别
    [self at_loadPanGesture];
    
    // 设置通知
    [self _setupNotification];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫 私有方法

#pragma mark 🚫 初始化

// 设置通知
- (void)_setupNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(receiveMessage:)
                                                name:NOTI_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(xmpp:)
                                                name:NOTI_XMPP object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(xmppConnectFail:)
                                                name:NOTI_XMPP_CONNECT_FAIL object:nil];
    
}


#pragma mark 🚫 懒加载

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

#pragma mark 🚫 通知

- (void)receiveMessage:(NSNotification *)noti{
    
    MessageModel *message = (MessageModel *)noti.object;
    [SCLAlertView at_showNotice:self title:message.fromJid subTitle:message.content closeButtonTitle:@"ok" duration:5.0f];
    
}


- (void)xmppConnectFail:(NSNotification *)noti{
    
    [SCLAlertView at_showError:self title:@"注册失败" subTitle:noti.object closeButtonTitle:@"ok" duration:0.0f];
    
}

- (void)xmpp:(NSNotification *)noti{
    
    if ([noti.object isEqualToString:NOTI_XMPP_CONNECT_FAIL]) {
        [SCLAlertView at_showError:self title:@"连接失败" subTitle:@"连接服务器错误" closeButtonTitle:@"ok" duration:0.0f];
    }
    
}




@end
