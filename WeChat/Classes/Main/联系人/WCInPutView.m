//
//  WCInPutView.m
//  WeChat
//
//  Created by 王哲 on 15/6/26.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCInPutView.h"

@implementation WCInPutView

+(instancetype)inputView{
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInPutView" owner:nil options:nil]lastObject];
}

@end
