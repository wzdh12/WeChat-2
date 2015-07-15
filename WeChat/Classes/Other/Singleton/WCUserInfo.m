//
//  WCUserInfo.m
//  WeChat
//
//  Created by 王哲 on 15/6/17.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCUserInfo.h"

#define UserKey @"user"
#define PwdKey @"pwd"
#define LoginStatus @"loginStatus"


@implementation WCUserInfo
singleton_implementation(WCUserInfo)

-(void)saveUserInfoToSanBox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:UserKey];
    [defaults setObject:self.pwd forKey:PwdKey];
    [defaults setBool:self.loginStatus forKey:LoginStatus];
    [defaults synchronize];
}
-(void)loadUserInfoFormSanBox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.user = [defaults objectForKey:UserKey];
    self.loginStatus = [defaults boolForKey:LoginStatus];
    self.pwd = [defaults objectForKey:PwdKey];
}
-(NSString *)jid{
    return [NSString stringWithFormat:@"%@@%@",self.user,domain];
}
@end
