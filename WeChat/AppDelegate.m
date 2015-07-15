//
//  AppDelegate.m
//  WzWeChat
//
//  Created by 王哲 on 15/6/15.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "AppDelegate.h"
#import "WCNavigationController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
@interface AppDelegate ()

@end


@implementation AppDelegate


#pragma mark -
#pragma mark appDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //沙盒路径
    NSString *str = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSLog(@"%@",str);
    //打开xmpp日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    //设置导航栏背景
    [WCNavigationController setupNavTheme];
    
    //从沙盒加载用户数据到单例里面
    [[WCUserInfo sharedWCUserInfo] loadUserInfoFormSanBox];
    
    //判断用户登陆状态 yes 就直接来到主界面    no 就进入到longin.storyboard
    if ([WCUserInfo sharedWCUserInfo].loginStatus == YES) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController = story.instantiateInitialViewController;
        //自动登录
        [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:nil];
    }
    return YES;
}

@end
