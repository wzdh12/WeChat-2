//
//  WCEditProfileViewController.m
//  WeChat
//
//  Created by 王哲 on 15/6/23.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCEditProfileViewController.h"
@interface WCEditProfileViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation WCEditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.cell.textLabel.text;
    self.textField.text = self.cell.detailTextLabel.text;
    
}
- (IBAction)Save:(id)sender {
    
    //1.更改self.cell.detailTextLabel.text信息
    self.cell.detailTextLabel.text = self.textField.text;
    
    [self.cell layoutSubviews];
    //2.当前控制器消失
    [self.navigationController popViewControllerAnimated:YES];
    
    //代理通知点击了保存按钮
    if (self.delegate && [self.delegate respondsToSelector:@selector(WCEditProfileViewControllerDidSave)]) {
        [self.delegate WCEditProfileViewControllerDidSave];
    }
}



@end
