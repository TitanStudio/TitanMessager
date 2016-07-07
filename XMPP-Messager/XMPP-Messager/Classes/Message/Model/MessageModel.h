//
//  MessageModel.h
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic , strong) NSString *time;
@property (nonatomic , strong) NSString *content;
@property (nonatomic , strong) NSString *headURL;
@property (nonatomic , assign) BOOL isFromMe;
@property (nonatomic , strong) NSString *fromJid;
@end
