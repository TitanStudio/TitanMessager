//
//  FriendsModel.h
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendsModel : NSObject

@property (nonatomic , strong) NSString *jid;

@property (nonatomic , strong) NSString *nickName;

@property (nonatomic , strong) NSString *group;

@property (nonatomic , assign) BOOL isBoth;
@end
