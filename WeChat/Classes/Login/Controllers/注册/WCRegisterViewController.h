//
//  WCRegisgerViewController.h
//  WeChat
//
//  Created by apple on 14/12/8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WCRegisterViewControllerDelegate <NSObject>

/**
 *  完成注册
 */
-(void)registerViewControllerDidFinishRegister;

@end
@interface WCRegisterViewController : UIViewController

@property (nonatomic, weak) id<WCRegisterViewControllerDelegate> delegate;

@end
