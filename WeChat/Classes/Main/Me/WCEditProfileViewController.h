//
//  WCEditProfileViewController.h
//  WeChat
//
//  Created by 王哲 on 15/6/23.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCEditProfileViewControllerDelegate <NSObject>

-(void)WCEditProfileViewControllerDidSave;

@end

@interface WCEditProfileViewController : UIViewController
@property (nonatomic,strong) UITableViewCell *cell;
@property (nonatomic,weak) id<WCEditProfileViewControllerDelegate>delegate;
@end
