//
//  WCProfileViewController.m
//  WeChat
//
//  Created by 王哲 on 15/6/19.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WCEditProfileViewController.h"
@interface WCProfileViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WCEditProfileViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;//微信号
@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *orgUnitLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//email
@end
@implementation WCProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    [self loadVCard];
}

-(void)loadVCard{
    XMPPvCardTemp *myVCard =   [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    //设置头像
    if (myVCard.photo) {
        self.headerView.image = [UIImage imageWithData:myVCard.photo];
    }
    //设置昵称
    self.nickNameLabel.text = myVCard.nickname;
    //设置微信号
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.weixinNumLabel.text = [NSString stringWithFormat:@"微信号：%@",user];
    //公司
    self.orgNameLabel.text = myVCard.orgName;
    //部门
    if (myVCard.orgUnits.count >0) {
        self.orgUnitLabel.text = myVCard.orgUnits[0];
    }
    //职位
    self.titleLabel.text = myVCard.title;
    //电话
#warning myVCard.telecomsAddresses 此get方法没有对电子名片电话的xml进行解析
    //使用note字段充当电话
    self.phoneLabel.text = myVCard.note;
    //email
#warning myVCard.telecomsAddresses 此get方法没有对电子名片电话的xml进行解析
    //使用mailer字段充当邮件
//    self.emailLabel.text = myVCard.mailer;
    //邮件解析
    if (myVCard.emailAddresses.count > 0) {
        self.emailLabel.text = myVCard.emailAddresses[0];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取cell.tag
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = cell.tag;
    if (tag == 2) {
        //不做任何操作
        return;
    }
    if (tag == 0) {//更改头像
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        [sheet showInView:self.view];
    }else{
        //修改 信息
        [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取编辑个人信息的控制
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[WCEditProfileViewController class]]) {
        WCEditProfileViewController *editVc = destVc;
        editVc.cell = sender;
        editVc.delegate = self;
    }
    
}
#pragma mark actionsheet delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        //取消
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //设置代理
    imagePicker.delegate = self;
    //设置允许编辑
    imagePicker.allowsEditing = YES;
    if (buttonIndex == 0) {
        //拍照
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if(buttonIndex == 1){
        //相册
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    //显示图片选择器
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark 图片选择器代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    WClog(@"%@",info);
    //获取图片 设置图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.headerView.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //更新
    [self WCEditProfileViewControllerDidSave];
}
#pragma mark 修改个人信息的控制器代理
-(void)WCEditProfileViewControllerDidSave{
    //保存
    
    

    //获取当前的电子名片模块
    XMPPvCardTemp *myVCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;

    //图片更新到服务器
    myVCard.photo = UIImagePNGRepresentation(self.headerView.image);
    
    //昵称
    myVCard.nickname = self.nickNameLabel.text;
    //公司
    myVCard.orgName = self.orgNameLabel.text;
    //部门
    if (self.orgUnitLabel.text.length >0) {
        myVCard.orgUnits = @[self.orgUnitLabel.text];
    }
    //职位
    myVCard.title = self.titleLabel.text;
    //电话
    myVCard.note = self.phoneLabel.text;
    //邮件
    if (self.emailLabel.text.length>0) {
        myVCard.emailAddresses = @[self.emailLabel.text];
    }
//    myVCard.mailer = self.emailLabel.text;

    //更新  ,这个方法内部会实现数据上传到服务器，不用自己操作
    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myVCard];
    
}
@end
