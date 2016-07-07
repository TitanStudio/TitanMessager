//
//  ATRootViewController.h
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabBarController.h"
#import "PersonalViewController.h"


@interface ATRootViewController : UIViewController

// 侧滑视图控制器
@property (strong, nonatomic) PersonalViewController *personalVC;
// 主tabbar控制器
@property (strong, nonatomic) BaseTabBarController *tabbarVC;


@end
