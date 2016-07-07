//
//  XMPPManager.h
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XMPP.h>
#import "MessageModel.h"
#import "FriendsModel.h"
#import "ChatFrameModel.h"

#define XMPP_DOMAIN   @"@aesir-imac.local"
#define XMPP_HOSTNAME @"192.168.1.106"
#define XMPP_HOSTPORT 5222
@interface XMPPManager : NSObject

// 注册
- (void)signupUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL ret))completion;

// 登录
- (void)loginUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL ret))completion;

// 获取所有好友
- (void)getAllFriendsWithJid:(NSString *)currentJid completion:(void (^)(BOOL ret, NSArray *allFriends))completion;

// 监听好友发送的消息
- (void)listenMessage:(void (^) (ChatFrameModel *message))frameModelBlock;

//发送消息
- (void)sendMessage:(MessageModel *)messageModel to:(NSString *)toJid comploetion:(void(^)(BOOL ret))completion;

// 单利
+ (instancetype)defaultManager;

@end
