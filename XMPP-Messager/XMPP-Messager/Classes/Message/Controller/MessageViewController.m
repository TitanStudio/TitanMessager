//
//  MessageViewController.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"消息";
    
    
    [self performSelector:@selector(userLogin) withObject:nil afterDelay:0.5f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)userLogin{
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
    
}

@end
