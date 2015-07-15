//
//  WCMeViewController.m
//  WeChat
//
//  Created by 王哲 on 15/6/17.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCMeViewController.h"
#import "XMPPvCardTemp.h"
@interface WCMeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headerView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;//微信号

@end

@implementation WCMeViewController
- (IBAction)LogOutBtnClick:(id)sender {
    //注销，直接调用 appdelegate  中的 Lougou 方法
//    AppDelegate *app = [UIApplication sharedApplication].delegate;
//    [app xmppUserLogOut];
    [[WCXMPPTool sharedWCXMPPTool] xmppUserLogOut];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //显示当前用户个人数据
    
    //如何使用coreData获取数据库
    //1.上下文【关联到数据库】
    //2.FetchRequest
    //3.设置过滤和排序
    //4.执请获取数据
    
    //xmpp 提供了一个方法，直接获取个人信息
   XMPPvCardTemp *myVcard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    //设置头像
    if (myVcard.photo) {
        self.headerView.image = [UIImage imageWithData:myVcard.photo];
    }
    //设置昵称
    self.nickNameLabel.text = myVcard.nickname;
    //设置头像
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.weixinNumLabel.text = [NSString stringWithFormat:@"微信号：%@",user];
}
@end
