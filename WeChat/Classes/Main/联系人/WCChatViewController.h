//
//  WCChatViewController.h
//  WeChat
//
//  Created by 王哲 on 15/6/26.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPJID.h"
@interface WCChatViewController : UIViewController
@property (nonatomic ,strong) XMPPJID *friendJid;
@end
