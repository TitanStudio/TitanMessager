//
//  DBManager.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "DBManager.h"
#import <FMDB.h>
static DBManager *sigle = nil;
@interface DBManager ()

@property (strong, nonatomic) FMDatabase *database;

@end

@implementation DBManager


+ (instancetype) defaultManager
{
    
    @synchronized(self) {
        if (sigle == nil) {
            sigle = [[self alloc]init];
        }
    }
    return sigle;
}

- (id)init
{
    if (sigle == nil) {
        sigle = [super init];
        //        1:获取沙盒主目录
        NSString *boundle =  NSHomeDirectory();
        //        2:获得documents
        NSString *documents = [boundle stringByAppendingString:@"/Documents/Message.db"];
        
        NSLog(@"%@",documents);
        //        3:初始化数据库
        self.database = [FMDatabase databaseWithPath:documents];
        
        //        4创建一张表
        [self createAMessageTable];
        
    }
    
    return sigle;
}


- (void)createAMessageTable
{
    [self executeTable:^BOOL{
        // 创建
        return [self.database executeUpdate:@"create table if not exists ChatMessage (ID integer Primary key autoincrement, time varchar(128) , content varchar(128) , headURL varchar(128) , isFromMe intrger ,fromJid varchar(128))"];
    }];
}

- (BOOL) insertAMessage:(MessageModel *)aMessage {
    
    return [self executeTable:^BOOL{
        // 插入
        return [self.database executeUpdate:@"insert into ChatMessage (time,content,headURL,isFromMe,fromJid) values (?,?,?,?,?)",aMessage.time,aMessage.content,aMessage.headURL,[NSNumber numberWithInteger:aMessage.isFromMe],aMessage.fromJid];
        
    }];
    
}

- (BOOL) deleteAMessage:(MessageModel *)aMessage {
	return [self executeTable:^BOOL{
        return [self.database executeUpdate:@"delete from ChatMessage where (time = ? and content = ?  and isFromMe = ? and fromJid = ?)",aMessage.time,aMessage.content,[NSNumber numberWithInteger:aMessage.isFromMe],aMessage.fromJid];
    }];
}

- (BOOL) updateAMessage:(MessageModel *)newMessage changedMessage:(MessageModel *)oldMessage {
	return [self executeTable:^BOOL{
        return [self.database executeUpdate:@"update ChatMessage set (time = ? and content = ?  and isFromMe = ? and fromJid = ?) where (time = ? and content = ? and headURL = ? and isFromMe = ? and fromJid = ?)",newMessage.time,newMessage.content,[NSNumber numberWithInteger:newMessage.isFromMe],newMessage.fromJid,oldMessage.time,oldMessage.content,oldMessage.headURL,[NSNumber numberWithInteger:oldMessage.isFromMe],oldMessage.fromJid];
    }];
}

- (NSArray *) selectAllMessageFrom:(NSString *)fromjid {
	
    // 1. 打开数据库
    if (!self.database.open) {
        return nil;
    }
    // 2. 开始根据条件查询好友消息
    FMResultSet *set = [self.database executeQuery:@"select * from ChatMessage where fromJid = ?",fromjid];
    
    NSMutableArray *allMessage = [NSMutableArray array];
    while ([set next]) {
        
        MessageModel *m = [[MessageModel alloc]init];
        
        m.time = [set objectForColumnName:@"time"];
        m.content = [set objectForColumnName:@"content"];
        m.fromJid = [set objectForColumnName:@"fromJid"];
        m.isFromMe = [set intForColumn:@"isFromMe"];
        m.headURL = [set objectForColumnName:@"headURL"];
        
        [allMessage addObject:m];
        
    }
    return allMessage;
}


- (BOOL)executeTable:(BOOL (^)())execute{
    // 1. 打开数据库
    if (!self.database.open) {
        return NO;
    }
    // 2. 检表
    BOOL ret = execute();
    // 3. 关闭数据库
    [self.database close];
    return ret;
}


@end
