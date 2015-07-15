//
//  WCContactsViewController.m
//  WeChat
//
//  Created by 王哲 on 15/6/24.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCContactsViewController.h"
#import "WCAddViewController.h"
#import "WCChatViewController.h"
@interface WCContactsViewController ()<NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_resultController;
}
@property (nonatomic ,strong) NSArray *friends;
@end

@implementation WCContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //从数据库里加载好友列表数据
    [self loadFirends2];
}
-(void)loadFirends2{
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].RosterCoreDataStorage.mainThreadManagedObjectContext;
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    // 过滤当前登录用户的好友
    NSString *jid = [WCUserInfo sharedWCUserInfo].jid;
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate = pre;
    
    //排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors = @[sort];
    
    // 4.执行请求获取数据
//    self.friends = [context executeFetchRequest:request error:nil];
//    NSLog(@"%@",self.friends);
    _resultController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    [_resultController performFetch:nil];
}
#pragma makr 当数据库的内容发生改变后会调用方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _resultController.fetchedObjects.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"ContactCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    //获取对应的好友
    XMPPUserCoreDataStorageObject *friend = _resultController.fetchedObjects[indexPath.row];
    //    sectionNum
    //    “0”- 在线
    //    “1”- 离开
    //    “2”- 离线
    switch ([friend.sectionNum intValue]) {//好友状态
        case 0:
            cell.detailTextLabel.text = @"在线";
            break;
        case 1:
            cell.detailTextLabel.text = @"离开";
            break;
        case 2:
            cell.detailTextLabel.text = @"离线";
            break;
        default:
            break;
    }
    cell.textLabel.text = friend.jidStr;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XMPPUserCoreDataStorageObject *friend = _resultController.fetchedObjects[indexPath.row];
        XMPPJID *firendJid = friend.jid;
        [[WCXMPPTool sharedWCXMPPTool].roster removeUser:firendJid];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //获取好友
    XMPPUserCoreDataStorageObject *friend = _resultController.fetchedObjects[indexPath.row];
    
    //选中表格进行聊天界面
    [self performSegueWithIdentifier:@"ChatSegue" sender:friend.jid];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVc = segue.destinationViewController;
    
    if ([destVc isKindOfClass:[WCChatViewController class]]) {
        WCChatViewController *chatVc = destVc;
        chatVc.friendJid = sender;
    }
}

- (IBAction)AddFriend:(UIButton *)sender {
    WCAddViewController *add = [[WCAddViewController alloc]initWithNibName:@"WCAddViewController" bundle:nil];
    [self.navigationController pushViewController:add animated:YES];
}


@end
