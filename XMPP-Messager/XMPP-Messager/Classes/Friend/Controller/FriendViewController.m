//
//  FriendViewController.m
//  XMPP-Messager
//
//  Created by Aesir Titan on 2016-07-07.
//  Copyright © 2016年 Titan Studio. All rights reserved.
//

#import "FriendViewController.h"
#import "XMPPManager.h"
//#import "MessageViewController.h"
#import "ChatViewController.h"
#import "FriendsModel.h"
@interface FriendViewController () <UITableViewDataSource, UITableViewDelegate>
@property (copy, nonatomic) NSString *myJid;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *allFriends;
@end

@implementation FriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self _init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取好友列表
- (void)fetchAllFirendWithJid:(NSString *)jid{
    
    [[XMPPManager defaultManager] getAllFriendsWithJid:jid completion:^(BOOL ret, NSArray *allFriends) {
        [self.allFriends addObjectsFromArray:allFriends];
        [self.tableView reloadData];
    }];
    
    
}

#pragma mark - 🚫🚫🚫🚫🚫🚫🚫🚫🚫🚫 私有方法

- (void)_init{
    
    self.navigationItem.title = @"好友";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.myJid = [[NSUserDefaults standardUserDefaults] objectForKey:@"jid"];
    // 查询好友列表
    [self fetchAllFirendWithJid:self.myJid];
}


- (NSMutableArray *)allFriends{
    
    if (!_allFriends) {
        _allFriends = [NSMutableArray array];
    }
    return _allFriends;
}


#pragma mark - 🔵🔵🔵🔵🔵🔵🔵🔵🔵🔵 数据源和代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    FriendsModel *fm = self.allFriends[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"7"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"昵称：%@",fm.nickName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"帐号：%@",fm.jid];
    
    return cell;
    
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    FriendsModel *fm = self.allFriends[indexPath.row];
    chatVC.friendsModel = fm;
    [self.navigationController pushViewController:chatVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}





@end
