//
//  WCLoginViewController.m
//  WeChat
//
//  Created by 王哲 on 15/6/17.
//  Copyright (c) 2015年 王哲. All rights reserved.
//
#import "WCNavigationController.h"
#import "WCLoginViewController.h"
#import "WCRegisterViewController.h"
@interface WCLoginViewController ()<WCRegisterViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;

@end

@implementation WCLoginViewController
- (IBAction)LoginBtnClick:(id)sender {
    //保存数据到单例
   WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = _userLabel.text;
    userInfo.pwd = _pwdField.text;
    
    //调用父类登陆
    [super login];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置密码TextField 和Btn的样式
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    [_LoginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    //设置用户名为上次登录的用户名
    //1.从沙盒获取用户名
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    _userLabel.text = user;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    UIButton *tempBtn = sender;
    if (tempBtn.tag == 99) {
        // 获取注册控制器
        id destVc = segue.destinationViewController;
        if ([destVc isKindOfClass:[WCNavigationController class]]) {
            WCNavigationController *nav = destVc;
            //获取根控制器
            WCRegisterViewController *registerVc =  (WCRegisterViewController *)nav.topViewController;
            // 设置注册控制器的代理
            registerVc.delegate = self;
        }

    }
}
-(void)RegisterViewControllerDidFinishRegister{
    WClog(@"完成注册");
    // 完成注册 userLabel显示注册的用户名
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].registerUser;
    
    // 提示
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
}
@end
