//
//  ChatFrameModel.h
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
@interface ChatFrameModel : NSObject
@property (nonatomic , strong) MessageModel *messageModel;

@property (nonatomic , assign)CGRect timeFrame;

@property (nonatomic , assign)CGRect contentFrame;

@property (nonatomic , assign)CGRect headFrame;

@property (nonatomic , assign) CGFloat cell_height;

@end
