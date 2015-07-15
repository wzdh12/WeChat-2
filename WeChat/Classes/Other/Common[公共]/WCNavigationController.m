//
//  WCNavigationController.m
//  WeChat
//
//  Created by 王哲 on 15/6/17.
//  Copyright (c) 2015年 王哲. All rights reserved.
//

#import "WCNavigationController.h"

@interface WCNavigationController ()

@end

@implementation WCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}
+(void)initialize{

    
}
+(void)setupNavTheme{
    //设置导航栏样式
    UINavigationBar  *navBar = [UINavigationBar appearance];
    
    //1。设置导航条背景
    //高度不会拉伸，但是宽度会拉伸
    [navBar setBackgroundImage:[UIImage stretchedImageWithName:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    //2. 设置导航栏字体
    NSMutableDictionary *att = [NSMutableDictionary new];
    att[NSForegroundColorAttributeName] = [UIColor whiteColor];
    att[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    [navBar setTitleTextAttributes:att];
    
    //要想此方法生效，需要在plist 文件中把 View controller-based status bar appearance 设置为 NO

    //设置状态栏的样式
    //xcode5 以上，默认的话，状态栏的样式由控制器决定
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

// 如果控制器是由导航控制器管理，设置状态栏的样式时，要在导航
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
@end
