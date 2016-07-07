//
//  DBManager.h
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface DBManager : NSObject

- (BOOL) insertAMessage:(MessageModel *)aMessage;


- (BOOL) deleteAMessage:(MessageModel *)aMessage;


- (BOOL) updateAMessage:(MessageModel *)newMessage changedMessage:(MessageModel *)oldMessage;


- (NSArray *) selectAllMessageFrom:(NSString *)fromjid;


+ (instancetype)defaultManager;

@end
