//
//  WCBaseLoginViewController.m
//  WeChat
//
//  Created by 王哲 on 15/6/17.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCBaseLoginViewController.h"
#import "AppDelegate.h"
@interface WCBaseLoginViewController ()

@end

@implementation WCBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
-(void)login{
    [self.view endEditing:YES];
    //2.登陆
    [MBProgressHUD showMessage:@"登陆中" toView:self.view];
    __weak typeof (self) selfVc = self;//弱引用,解决因为 block 引起的内存泄漏
    [WCXMPPTool sharedWCXMPPTool].RegisterOperation = NO;
    
    [[WCXMPPTool sharedWCXMPPTool] xmppUserLogin:^(XMPPResultType type) {
    [selfVc handleResultType:type];
    }];
}
-(void)handleResultType:(XMPPResultType) type{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                [self enterMainView];
                break;
            case XMPPResultTypeLoginFailure:
                [ MBProgressHUD showError:@"用户名或者密码不正确" toView:self.view];
                break;
            case XMPPResultTypeNetError:
                [ MBProgressHUD showError:@"网络不给力，请检查网络" toView:self.view];
                break;
            default:
                break;
        }
    });
}
-(void)enterMainView{
    
    //更改用户的登录状态为 yes
    [WCUserInfo sharedWCUserInfo].loginStatus = YES;
    
    //把用户登录成功的数据，保存到沙盒
    [[WCUserInfo sharedWCUserInfo] saveUserInfoToSanBox];
    
    //隐藏模态窗口
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    //登陆成功，来到主界面
    //代理方法是在子线程中被调用的，所以要在主线程中刷新ui
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.view.window.rootViewController = story.instantiateInitialViewController;
  #warning 在IOS7 中上面两行代码不起作用
    [UIStoryboard showInitialVCWithName:@"Main"];
}
@end
