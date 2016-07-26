//
//  XMPPManager.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "XMPPManager.h"
#import <SCLAlertView.h>

@interface XMPPManager () <XMPPStreamDelegate>

@property (strong, nonatomic) XMPPStream *stream;

@property (strong, nonatomic) NSString *currentPassword;

@property (assign, nonatomic) BOOL isLogin;


@property (nonatomic , copy) void (^callBack) (BOOL ret);

//用于保存 查询所有好友列表的 block
@property (nonatomic , copy) void (^getFirends) (BOOL ret ,NSArray *allFirends);

//用于保存 监听好友发送给我消息的block
@property (nonatomic, copy) void (^getMessageBlcok) (ChatFrameModel *message);

//用于保存 发送消息成功的block
@property (nonatomic,copy) void (^sendMessage)(BOOL ret);


@end

@implementation XMPPManager


static XMPPManager *sigle = nil;






- (void)signupUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL ret))completion {
	
    self.isLogin = NO;
    self.callBack = completion;
    [self connectWithUsername:username password:password];
    
}

- (void)loginUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL ret))completion {
	
    self.isLogin = YES;
    self.callBack = completion;
    [self connectWithUsername:username password:password];
    
}

- (void)getAllFriendsWithJid:(NSString *)currentJid completion:(void (^)(BOOL ret, NSArray *allFriends))completion {
	
    self.getFirends = completion;
    
    // 1:发起一个接口请求，去jabber服务器 查询当前JID下的所有的好友
    // interfceQuery

    // 创建一个父子节点  叫 iq  属性名 ：iq
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    
    // 把字符串形式的jid转换成XMPPJID对象
    XMPPJID *myJid = [XMPPJID jidWithString:currentJid];
    // 告诉服务器 查询来自哪个jid的信息
    [iq addAttributeWithName:@"from" stringValue:myJid.description];
    // 本次获取数据的请求方式 get
    [iq addAttributeWithName:@"type" stringValue:@"get"];
    
    // 创建一个查询指令的XML子节点 (父节点 属性名:iq 描述信息是:指定jabber 执行IQ 目标表 roster)
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:roster"];
    // 让query座位iq的子节点
    [iq addChild:query];
    
    // 向服务器发送查询指令, 结果在代理中监听
    [self.stream sendElement:iq];
    
}

- (void)listenMessage:(void (^) (ChatFrameModel *message))frameModelBlock {
    self.getMessageBlcok = frameModelBlock;
}

- (void)sendMessage:(MessageModel *)messageModel to:(NSString *)toJid comploetion:(void(^)(BOOL ret))completion {
    
    // 保留传入block
    self.sendMessage = completion;
    
    // 创建一个消息节点放置消息内容
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:messageModel.content];
    // 创建message父节点, 表示这是一条消息发送
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:toJid];
    
    [message addChild:body];
    [self.stream sendElement:message];
	
}



+ (instancetype)defaultManager {
    @synchronized(self) {
        
        if (!sigle) {
            sigle = [[self alloc]init];
        }
    }
    
    return sigle;
}

- (instancetype)init{
    @synchronized (self) {
        if (self = [super init]) {
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(offLine) name:NOTI_XMPP object:NOTI_XMPP_DISCONNECT];
            
        }
        return self;
    }
    
}


// stream懒加载
- (XMPPStream *)stream{
    
    if (!_stream) {
        // 创建
        _stream = [[XMPPStream alloc] init];
        // 绑定服务器
        NSString *newHost = [[NSUserDefaults standardUserDefaults] objectForKey:XMPP_HOSTNAME];
        if (newHost.length) {
            [_stream setHostName:newHost];
        } else {
            [_stream setHostName:XMPP_HOSTNAME];
        }
        // 绑定端口
        [_stream setHostPort:5222];
        // 设置代理
        [_stream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _stream;
    
}

// 离线
- (void)offLine{
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.stream sendElement:presence];
    [self.stream disconnect];
    
}

// 连接服务器
- (void)connectWithUsername:(NSString *)username password:(NSString *)password{
    
    // 保存当前密码
    self.currentPassword = password;
    
    // 封装jid
    NSString *newDomain = [[NSUserDefaults standardUserDefaults] objectForKey:XMPP_DOMAIN];
    if (newDomain.length) {
        username = [username stringByAppendingString:newDomain];
    } else {
        username = [username stringByAppendingString:XMPP_DOMAIN];
    }
    
    XMPPJID *jid = [XMPPJID jidWithString:username];
    self.stream.myJID = jid;
    
    
    // 判断当前是否已经连接了, 如果已经连接了就断开
    if (self.stream.isConnected) {
        [self offLine];
    }
    
    // 连接服务器(状态结果在 xmppstream的代理中返回)
    [self.stream connectWithTimeout:5 error:nil];
    
    
}


#pragma mark - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 数据源和代理

// 连上了服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    DEBUG_LOG(@"连接上了服务器");
    if (self.isLogin) {
        [self.stream authenticateWithPassword:self.currentPassword error:nil];
    } else{
        [self.stream registerWithPassword:self.currentPassword error:nil];
    }
    
}

// 连接失败了
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    DEBUG_LOG_OBJ(@"连接失败了", error.description);
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_XMPP object:NOTI_XMPP_CONNECT_FAIL];
}

// 连接成功
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    DEBUG_LOG(@"连接成功");
    // 显示在线
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"available"];
    [self.stream sendElement:presence];
    self.callBack(YES);
    DEBUG_FUNC;
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_XMPP object:NOTI_XMPP_CONNECT_SUCCESS];
    
    
}

// 连接失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    DEBUG_LOG_OBJ(@"连接失败",error.description);
    self.callBack(NO);
    
}

// 注册成功
- (void)xmppStreamDidRegister:(XMPPStream *)sender{
    DEBUG_LOG(@"注册成功");
    self.callBack(YES);
}

// 注册失败
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    DEBUG_LOG_OBJ(@"注册失败",error.description);
    self.callBack(NO);
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_XMPP_CONNECT_FAIL object:error];
}

// 发送查询指令成功
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq{
    DEBUG_LOG(@"发送查询指令成功");
}

// 收到查询结果
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    DEBUG_LOG(@"收到查询结果");
    DEBUG_LOG_OBJ(@"结果", iq);
    
    // 通过指定节点的名称, 取出同名的所有节点
    NSArray *querys = [iq elementsForName:@"query"];
    DEBUG_LOG_OBJ(@"querys", querys);
    NSXMLElement *query = querys.firstObject;
    NSArray *items = [query elementsForName:@"item"];
    DEBUG_LOG_OBJ(@"items", items);
    
    // 遍历items取出所有好友
    NSMutableArray *allFriends = [NSMutableArray array];
    for (NSXMLElement *item in items) {
        // 通过属性的名字 拿到该属性 然后转换成 字符串
        NSString *fName = [[item attributeForName:@"name"] stringValue];
        NSString *fJid = [[item attributeForName:@"jid"] stringValue];
        NSString *group = [[[item elementsForName:@"group"] lastObject] stringValue];
        
        FriendsModel *fm = [[FriendsModel alloc]init];//创建一个好友模型
        // 为模型的各个属性复制
        fm.nickName = fName;
        fm.jid = fJid;
        fm.group = group;
        fm.isBoth = YES;
        
        [allFriends addObject:fm];
        
    }
    
    // 抛出封装好的数据
    self.getFirends(YES,allFriends);
    return YES;
    
}

// 监听好友发送的信息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    DEBUG_LOG(@"好友发来了信息");
    NSString *body = message.body;
    if (body.length) {
        // 来自谁的消息
        NSString *fromJid = message.from.bare;
        NSString *toJid = message.to.bare;
        // 创建消息模型
        MessageModel *currentMessage = [[MessageModel alloc] init];
        currentMessage.content = body;
        currentMessage.isFromMe = NO;
        currentMessage.fromJid = fromJid;
        
        // 创建一个时间格式化对象
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyy-MM-dd HH-mm-ss";
        // 获取当前时间
        NSDate *currentDate = [NSDate date];
        // 将当前时间按照指定格式创建字符串
        NSString *currentDateString = [formatter stringFromDate:currentDate];
        currentMessage.time = currentDateString;
        
        // 创建一个frame model
        ChatFrameModel *fm = [[ChatFrameModel alloc]init];
        //        走set方法，会动态计算 虽有 控件的frame
        fm.messageModel = currentMessage;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_MESSAGE object:currentMessage];
        
        //        启动blocl之前 判断一下当前block是否实现
        if (self.getMessageBlcok) {
            self.getMessageBlcok(fm);//启动block
        }

        
    }
    
}


- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message{
    DEBUG_LOG(@"发送消息成功");
    self.sendMessage(YES);
}


@end
