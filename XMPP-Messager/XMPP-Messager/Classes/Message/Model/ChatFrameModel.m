//
//  ChatFrameModel.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "ChatFrameModel.h"

#define SPACE_W 15
#define SPACE_TOP 10
#define IMAGE_W 55
#define IMAGE_H 55
#define TIME_H 25

@implementation ChatFrameModel

- (void)setMessageModel:(MessageModel *)messageModel{
    
    _messageModel = messageModel;
    
    // 计算时间按钮的位置
    self.timeFrame = CGRectMake(0, 0, SCREEN_W, TIME_H);
    
    // 计算内容按钮的尺寸
    CGRect textSize = [messageModel.content boundingRectWithSize:CGSizeMake(SCREEN_W - IMAGE_W * 2 - SPACE_W * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    
    // 计算每一个控件的尺寸
    if (messageModel.isFromMe) {
        self.headFrame = CGRectMake(SCREEN_W - SPACE_W - IMAGE_W, TIME_H, IMAGE_W, IMAGE_H);
        self.contentFrame = CGRectMake(CGRectGetMaxX(self.headFrame) - IMAGE_W - textSize.size.width - SPACE_W - 50, TIME_H, textSize.size.width + 50, textSize.size.height + 50);
    } else {
        self.headFrame = CGRectMake(SPACE_W, TIME_H, IMAGE_W, IMAGE_H);
        self.contentFrame = CGRectMake(CGRectGetMaxX(self.headFrame) + SPACE_W, TIME_H, textSize.size.width + 50, textSize.size.height + 50);
    }
    
    BOOL ret = CGRectGetMaxY(self.contentFrame) > CGRectGetMaxY(self.headFrame);
    self.cell_height = (ret? CGRectGetMaxY(self.contentFrame) : CGRectGetMaxY(self.headFrame)) + SPACE_W;
    
}

@end
