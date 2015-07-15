//
//  WCOtherLoginViewController.m
//  WeChat
//
//  Created by 王哲 on 15/6/16.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCOtherLoginViewController.h"
#import "AppDelegate.h"
@interface WCOtherLoginViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WCOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"其它方式登录";
    
    // 判断当前设备的类型  改变左右两边约束的距离
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone){
        _leftConstraint.constant = 10;
        _rightConstraint.constant = 10;
    }
    //设置textfield的背景
    _userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    _pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    [_loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}

- (IBAction)loginBtnClick {
    //1.把用户名和密码放在WCUserInfo 中
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = _userField.text;
    userInfo.pwd = _pwdField.text;
   
    //调用父类方法
    [super login];
    
  }
- (IBAction)cancel:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
