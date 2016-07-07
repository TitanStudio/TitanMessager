//
//  ChatViewController.h
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendsModel.h"
@interface ChatViewController : BaseViewController
@property (strong, nonatomic) FriendsModel *friendsModel;
@end
