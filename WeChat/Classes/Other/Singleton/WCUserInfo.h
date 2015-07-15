//
//  WCUserInfo.h
//  WeChat
//
//  Created by 王哲 on 15/6/17.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
static NSString *domain = @"teacher.local";
@interface WCUserInfo : NSObject
singleton_interface(WCUserInfo);
@property (nonatomic ,copy) NSString *user;//用户名
@property (nonatomic ,copy) NSString *pwd;// 密码
/**
 *  //登录的状态  yes登录过   no注销
 */
@property (nonatomic ,assign) BOOL loginStatus;

@property (nonatomic ,copy) NSString *registerUser;//注册时用户名
@property (nonatomic ,copy) NSString *registerPwd;//注册时密码
@property (nonatomic ,copy) NSString *jid;
/**
 *  获取用户数据
 */
-(void)loadUserInfoFormSanBox;
/**
 *  保存用户数据到沙盒
 */
-(void)saveUserInfoToSanBox;

@end
