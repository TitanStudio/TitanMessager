//
//  MainTabbarController.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "MainTabbarController.h"

@interface MainTabbarController ()

@property (weak, nonatomic) UIGestureRecognizer *pan;

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _setupPanGestureRecongizer];
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



- (void)_setupPanGestureRecongizer{
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.pan = pan;
    [self.view addGestureRecognizer:pan];
    
}

- (void)panAction:(UIPanGestureRecognizer *)pan{
    
    if (pan && pan.state == UIGestureRecognizerStateBegan) {
        CGPoint translation = [pan translationInView:self.view];
        CGPoint location = [pan locationInView:self.view];
        DEBUG_LOG_POINT(location);
        // 过滤
        if (location.x > 100 || fabs(translation.y) > 100) {
            return;
        }
        
        if (translation.x < 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_LEFTVIEW object:NOTI_LEFTVIEW_CLOSE];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_LEFTVIEW object:NOTI_LEFTVIEW_OPEN];
        }
        
        
        
    }
    
}






@end
