//
//  WCXMPPTool.m
//  WeChat
//
//  Created by 王哲 on 15/6/18.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCXMPPTool.h"


@interface WCXMPPTool ()<XMPPStreamDelegate>
{
//    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
    
    XMPPvCardCoreDataStorage *_vCardSotrage;//电子名片数据存储
    
    XMPPvCardAvatarModule *_Avatar;//头像模块
    XMPPReconnect *_reconnect; //自动连接模块
}
/**
 *  在appdelegate 中实现登陆
 1.初始化XMPPStream
 2.连接到服务器（传一个JID）
 3.连接到服务器成功后，再发送密码授权
 4.授权成功后，发送”在线“消息
 */

//1.初始化XMPPStream
-(void)setupXMPPStream;
//2.连接到服务器（传一个JID）
-(void)connectToHost;
//3.连接到服务器成功后，再发送密码授权
-(void)sendPwdToHost;
//4.授权成功后，发送”在线“消息
-(void)sendOnlineToHost;
@end


@implementation WCXMPPTool
singleton_implementation(WCXMPPTool);

#pragma mark - 私有方法
#pragma mark 1.初始化XMPPStream
-(void)setupXMPPStream{
    _xmppStream = [[XMPPStream alloc]init];
#warning 每一个模块添加后都要激活
    //添加自动连接模块
    _reconnect = [[XMPPReconnect alloc]init];
    [_reconnect activate:_xmppStream];
    
    //添加电子名片模块
    _vCardSotrage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardSotrage];
    //激活电子名片模块
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _Avatar = [[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    [_Avatar activate:_xmppStream];
    
    //添加花名册模块 获取好友列表
    _RosterCoreDataStorage = [[XMPPRosterCoreDataStorage alloc]init];
    _roster = [[XMPPRoster alloc]initWithRosterStorage:_RosterCoreDataStorage];
    [_roster activate:_xmppStream];
    
    //添加聊天模块
    _msgStorage = [[XMPPMessageArchivingCoreDataStorage alloc]init];
    _msgArchiving = [[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_msgStorage];
    [_msgArchiving  activate:_xmppStream];
    
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}
#pragma mark 2.连接到服务器（传一个JID）
-(void)connectToHost{
    WClog(@"开始连接服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    //设置登陆用户jid
    // resource 标识用户登陆的客户端 是  iphone or andriod
    //从WCUserInfo  用户名
    
    NSString *user = nil;
    if (self.isRegisterOperation) {
        user = [WCUserInfo sharedWCUserInfo].registerUser;
    }else{
        user = [WCUserInfo sharedWCUserInfo].user;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"teacher.local" resource:@"iphone"];
    _xmppStream.myJID = myJID;
    // 设置服务器 域名
    _xmppStream.hostName = @"127.0.0.1";//不仅可以是域名，还可以是ip地址
    //设置端口   ,如果服务器的端口是5222，可以省略
    _xmppStream.hostPort = 5222;
    
    NSError *error = nil;
    //连接
    if(![ _xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        WClog(@"%@",error);
    }
}
#pragma mark 3.连接到服务器成功后，再发送密码授权
-(void)sendPwdToHost{
    WClog(@"发送密码授权");
    //从WCUserInfo单例中获取 密码
    NSString *pwd = [WCUserInfo sharedWCUserInfo].pwd;
    NSError *error = nil;
    [_xmppStream authenticateWithPassword:pwd error:&error];
    if (error ) {
        WClog(@"%@",error);
    }
}
#pragma mark 4.授权成功后，发送”在线“消息
-(void)sendOnlineToHost{
    WClog(@"发送”在线“消息");
    XMPPPresence *presence = [XMPPPresence presence];
    [_xmppStream sendElement:presence];
}
#pragma mark - _xmppStream  delegate
#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    WClog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {//注册操作，发送注册密码
        NSString *pwd = [WCUserInfo sharedWCUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{
        //登录操作，发送登录密码进行授权
        [self  sendPwdToHost];
    }
}
#pragma mark 与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    //如果有错误，代表连接失败
    //如果没有错误，表示正常的断开连接（人为的断开连接）
    WClog(@"与主机断开连接%@",error);
    if (error && _resultBlock ) {
        _resultBlock(XMPPResultTypeNetError);
    }
}
#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    WClog(@"授权成功");
    [self sendOnlineToHost];
    
    //回调控制器登陆成功
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
}
#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    WClog(@"授权授权失败%@",error);
    //判断block 有无值，再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}
#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    WClog(@"注册成功");
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}
#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    WClog(@"注册失败%@",error);
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}

#pragma mark -
#pragma mark 公共方法 注销
-(void)xmppUserLogOut{
    //1.发送“离线”消息
    XMPPPresence *OffLine = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:OffLine];
    //2.与服务器断开连接
    [_xmppStream disconnect];
    //回到登陆界面
    

//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
//    self.window.rootViewController = story.instantiateInitialViewController;
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    //4. 更新用户的登录状态
    [WCUserInfo sharedWCUserInfo].loginStatus = NO;
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanBox];
}
//登录
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    //先把block存起来
    _resultBlock = resultBlock;
    
    //如果以前连接过服务器，要断开
    //不管有没有连接过，都断开
    [_xmppStream disconnect];
    
    //连接到主机，成功后发送登陆密码
    [self connectToHost];
}
//注册
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock{
    //先把block存起来
    _resultBlock = resultBlock;
    
    //如果以前连接过服务器，要断开
    //不管有没有连接过，都断开
    [_xmppStream disconnect];
    //连接主机，成功后发送注册密码
    [self connectToHost];
}
#pragma mark 释放xmppStream相关的资源
-(void)teardownXmpp{
    // 移除代理
    [_xmppStream removeDelegate:self];
   
    // 停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_Avatar deactivate];
    [_roster deactivate];
    [_msgArchiving deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    
    // 清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCardSotrage = nil;
    _Avatar = nil;
    _xmppStream = nil;
    _roster = nil;
    _RosterCoreDataStorage = nil;
    _msgArchiving = nil;
    _msgStorage = nil;
}
-(void)dealloc{
    [self teardownXmpp];
}
@end
