//
//  WCInPutView.h
//  WeChat
//
//  Created by 王哲 on 15/6/26.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCInPutView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
+(instancetype)inputView;
@end
