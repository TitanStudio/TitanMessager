//
//  BaseTabBarController.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"

#import "MessageViewController.h"
#import "FriendViewController.h"
#import "DiscoverViewController.h"
#import "MeViewController.h"

@interface BaseTabBarController ()


@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _initUI];
    [self _setupChildViewControllers];
    [self _setupTabbarItems];
    
    
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

- (void)_initUI{
    
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowRadius = 2.0f;
    self.view.layer.shadowOffset = CGSizeMake(-1.5, 0);
    self.view.layer.shadowOpacity = 0.5;
}

- (void)_setupTabbarItems{
    
    UITabBarItem *item = [UITabBarItem appearance];
    // 普通状态下的文字
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
//    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    
    // 选中状态下的文字
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = COLOR_TINT;
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
    [UITabBar appearance].tintColor = COLOR_TINT;
    [UITabBar appearance].barTintColor = [UIColor whiteColor];
    
}

- (void)_setupChildViewControllers{
    
    // 添加子控制器
    [self _setupChlidController:[[BaseNavigationController alloc] initWithRootViewController:[[MessageViewController alloc] init]] title:@"消息" image:@"tabbar_mainframe" selectedImage:@"tabbar_mainframeHL"];
    [self _setupChlidController:[[BaseNavigationController alloc] initWithRootViewController:[[FriendViewController alloc] init]] title:@"朋友" image:@"tabbar_contacts" selectedImage:@"tabbar_contactsHL"];
    [self _setupChlidController:[[BaseNavigationController alloc] initWithRootViewController:[[DiscoverViewController alloc] init]] title:@"发现" image:@"tabbar_discover" selectedImage:@"tabbar_discoverHL"];
    [self _setupChlidController:[[BaseNavigationController alloc] initWithRootViewController:[[MeViewController alloc] init]] title:@"我" image:@"tabbar_me" selectedImage:@"tabbar_meHL"];
    
    
    
    
}


- (void)_setupChlidController:(BaseNavigationController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    vc.tabBarItem.title = title;
    if (image.length) {
        vc.tabBarItem.image = [UIImage imageNamed:image];
        vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    
    [self addChildViewController:vc];
    
}




@end
