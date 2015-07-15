//
//  WCChatViewController.m
//  WeChat
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "WCChatViewController.h"
#import "WCInputView.h"

@interface WCChatViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UITextViewDelegate>
{
    NSFetchedResultsController *_resultController;
}
@property (nonatomic, strong) NSLayoutConstraint *inputViewBottomConstraint;//inputView底部约束
@property (nonatomic, strong) NSLayoutConstraint *inputViewHeightConstraint;//inputView高度约束
@property (nonatomic ,weak) UITableView *tableview;
@end

@implementation WCChatViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupView];
    // 键盘监听
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self loadMsgs];
    NSLog(@"%@",self.friendJid);
}

-(void)keyboardWillShow:(NSNotification *)noti{
    NSLog(@"%@",noti);
    // 获取键盘的高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat kbHeight =  kbEndFrm.size.height;
    
    //竖屏{{0, 0}, {768, 264}
    //横屏{{0, 0}, {352, 1024}}
    // 如果是ios7以下的，当屏幕是横屏，键盘的高度是size.width
    if([[UIDevice currentDevice].systemVersion doubleValue] < 8.0
       && UIInterfaceOrientationIsLandscape(self.interfaceOrientation)){
        kbHeight = kbEndFrm.size.width;
    }
    self.inputViewBottomConstraint.constant = kbHeight;
    //表格滚动到底部
    [self scrollToTableBottom];
}

-(void)keyboardWillHide:(NSNotification *)noti{
    // 隐藏键盘的时候，距离底部的约束永远为0
    self.inputViewBottomConstraint.constant = 0;
}
-(void)setupView{
    // 代码方式实现自动布局 VFL
    // 创建一个Tableview;
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor redColor];
    self.tableview = tableView;
    
#warning 代码实现自动布局，要设置下面的属性为NO
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    
    // 创建输入框View
    WCInPutView *inputView = [WCInPutView inputView];
    //设置textView 的代理
    inputView.textView.delegate = self;
    inputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:inputView];
    
    // 自动布局
    // 水平方向的约束
    NSDictionary *views = @{@"tableview":tableView,
                            @"inputView":inputView};
    
    // 1.tabview水平方向的约束
    // @"H:|-0-[tableview]-0-|"  H代表水平方向的约束， |-0代表距离父控件左边距为0， -0|代表距离父控件dk边距为0，
    NSArray *tabviewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[tableview]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:tabviewHConstraints];
    
    // 2.inputView水平方向的约束
    NSArray *inputViewHConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[inputView]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:inputViewHConstraints];
    
    // 垂直方向的约束
    NSArray *vContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[tableview]-0-[inputView(50)]-0-|" options:0 metrics:nil views:views];
    [self.view addConstraints:vContraints];
    //添加inputVIew 的高度约束
    self.inputViewHeightConstraint = vContraints[2];
    self.inputViewBottomConstraint = [vContraints lastObject];
    NSLog(@"%@",vContraints);
}
#pragma mark  加载 XMPPMessageArchiving 数据库数据显示在表格里
-(void)loadMsgs{
    //    //上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].msgStorage.mainThreadManagedObjectContext;
    //    //请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
     //过虑、排序
     //1.当前登录用户的jid的消息 streamBareJidStr
     //2.好友的jid的信息 bareJidStr
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr =%@ AND bareJidStr = %@ ",[WCUserInfo sharedWCUserInfo].jid,self.friendJid.bare];
    request.predicate = pre;
     //排序 (时间升序)
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
     //查询
     // 4.执行请求获取数据
    _resultController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultController.delegate = self;
    [_resultController performFetch:nil];
}
#pragma makr 当数据库的内容发生改变后会调用方法
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableview reloadData];
    [self scrollToTableBottom];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultController.fetchedObjects.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"ChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    //获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject * msg = _resultController.fetchedObjects[indexPath.row];
    if ([msg.outgoing boolValue] == YES) { //自己发送
        cell.textLabel.text = [NSString stringWithFormat:@"ME:%@",msg.body];
    }else{//别人发送
        cell.textLabel.text = [NSString stringWithFormat:@"Other:%@",msg.body];
    }
    return cell;
}
#pragma makr textview delegate
-(void)textViewDidChange:(UITextView *)textView{
    //获取 ContentSize
    CGFloat contentH = textView.contentSize.height;
    NSLog(@"size.height = %f",contentH);
    //大于33，超过一行的高度
    //小于68，高度在3行内
    if (contentH >33 && contentH < 68 ) {
        self.inputViewHeightConstraint.constant = contentH + 18;
    }
    
    NSString *text = textView.text;
    // 换行就等于点击了的send
    //点击send 换行，而换行就相当于send
    if ([text rangeOfString:@"\n"].length != 0) {
        NSLog(@"发送数据 %@",text);
        //去除换行字符->固定写法
        text  = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self sendMsgWithText:text];
        //清空数据
        textView.text = nil;
        
        //发送完消息，要把Inputview 的高度改回来
        self.inputViewHeightConstraint.constant = 50;
    }else{
        NSLog(@"%@",textView.text);
    }
}
#pragma mark 发送聊天消息
-(void)sendMsgWithText:(NSString *)text{
    
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    // 设置内容
    [msg addBody:text];
    NSLog(@"%@",msg);
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:msg];
}
#pragma mark 滚动到底部
-(void)scrollToTableBottom{
    NSInteger lastRow = _resultController.fetchedObjects.count - 1;
    if (lastRow<0) {//如果小于0，不能滚动
        return;
    }
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableview scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
@end
