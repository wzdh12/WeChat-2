//
//  WCXMPPTool.h
//  WeChat
//
//  Created by 王哲 on 15/6/18.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

typedef enum {
    XMPPResultTypeLoginSuccess,//登陆成功
    XMPPResultTypeLoginFailure,//登陆失败
    XMPPResultTypeNetError,//网络问题
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;
typedef void (^XMPPResultBlock)(XMPPResultType type);//XMPP请求结果的block

@interface WCXMPPTool : NSObject

singleton_interface(WCXMPPTool)

/**
 *  注册标识   yes 代表注册  no代表 登录
 *
 */
@property (nonatomic,assign, getter=isRegisterOperation) BOOL RegisterOperation;//注册操作

@property (nonatomic ,strong,readonly) XMPPvCardTempModule *vCard;//电子名片;
@property (nonatomic ,strong,readonly)     XMPPRosterCoreDataStorage *RosterCoreDataStorage;//花名册模块数据存储
@property (nonatomic ,strong,readonly) XMPPRoster *roster;//花名册模块
@property (nonatomic, strong,readonly)XMPPStream *xmppStream;
//聊天模块
@property (nonatomic ,strong,readonly) XMPPMessageArchiving *msgArchiving;
@property (nonatomic ,strong,readonly) XMPPMessageArchivingCoreDataStorage *msgStorage;

//用户登陆
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock;
//注销
-(void)xmppUserLogOut;
//注册
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock;

@end
