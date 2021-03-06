//
//  AppDelegate.m
//  WK天气
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 王琨. All rights reserved.
//

#import "AppDelegate.h"
#import "WKMapManager.h"
#import "WKBriefWeatherVC.h"
#import "WKMainPageVC.h"


@interface AppDelegate ()

@end

static BOOL isShow = NO;//用于控制延时定位是否使用，因为使用3DTouch进入已经查看了，所以不能再延时定位

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!isShow) {
            [[WKMapManager shardMapManager] startLocationWithBlock:^(NSString *name) {
                [self showBriefWeather:name isTouch:NO];
            }];
        }


    });

    
    // 创建标签的ICON图标。
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLocation];
    // 创建一个标签，并配置相关属性。
    UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"one" localizedTitle:@"查看天气" localizedSubtitle:@"当前所在城市" icon:icon userInfo:nil];
    // 将标签添加进Application的shortcutItems中。
    [UIApplication sharedApplication].shortcutItems = @[item];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//前提全为模态推送的问题~
- (WKModelBaseVC *)correctVC
{
    WKModelBaseVC * vc = self.window.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
    };
    return vc;
}

- (void)application:(UIApplication *)application
performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem
  completionHandler:(void(^)(BOOL succeeded))completionHandler{

    isShow = YES; //3dtouch进入时，则设置为Yes防止延时定位调用
    [[WKMapManager shardMapManager] startLocationWithBlock:^(NSString *name) {
        [self showBriefWeather:name isTouch:YES];
    }];
}

///判断是否是3DTouch进入
- (void)showBriefWeather:(NSString *)cityName isTouch:(BOOL)isTouch
{
    
    NSLog(@"%@",cityName);
    NSString * cn = [WKUserInfomation getCityName];
    if ([cn isEqualToString:cityName]) {
        return;
    }
    
    NSArray * citys = [[WKUserInfomation shardUsrInfomation] allKeys];
    
    BOOL flag = NO;
    NSUInteger index = 0;
    for (NSString * str in citys) {
        if ([str isEqualToString:cityName]) {
            flag = YES;
            index = [citys indexOfObject:str];
            break;
        }
    }
    
    NSString * title = [NSString stringWithFormat:@"您现在正位于【%@】",cityName];
    
    WKModelBaseVC * baseVC = [self correctVC];

    //3DTouch进入
    if (isTouch) {
        if (!flag) {
            //新界面
            WKBriefWeatherVC * vc = [[WKBriefWeatherVC alloc] init];
            baseVC.am = [[WKAnimatorManager alloc] init];
            baseVC.am.style = WKAnimatorStyle_WindowedModel;
            baseVC.am.toViewHeight = 280;
            vc.cityName = cityName;
            vc.transitioningDelegate = baseVC.am;
            vc.modalPresentationStyle = UIModalPresentationCustom;
            [baseVC presentViewController:vc animated:YES completion:nil];
        }
        else
        {
            if ([baseVC isKindOfClass:[WKMainPageVC class]]) {
                ((WKMainPageVC *)baseVC).presentIndex = index;
            }
        }
        return;
    }
    
    //正常打开进入
    WKAlertView * av =  [WKAlertView showAlertViewWithStyle:WKAlertViewStyleWaring noticStyle:WKAlertViewNoticStyleFace title:title detail:@"是否需要查看该城市天气？" canleButtonTitle:@"不用" okButtonTitle:@"好的" callBlock:^(MyWindowClick buttonIndex) {
        if (buttonIndex == 0) {
            if (!flag) {
                //新界面
                WKBriefWeatherVC * vc = [[WKBriefWeatherVC alloc] init];
                baseVC.am = [[WKAnimatorManager alloc] init];
                baseVC.am.style = WKAnimatorStyle_WindowedModel;
                baseVC.am.toViewHeight = 280;
                vc.cityName = cityName;
                vc.transitioningDelegate = baseVC.am;
                vc.modalPresentationStyle = UIModalPresentationCustom;
                [baseVC presentViewController:vc animated:YES completion:nil];
            }
            else
            {
                if ([baseVC isKindOfClass:[WKMainPageVC class]]) {
                    ((WKMainPageVC *)baseVC).presentIndex = index;
                }
            }
        }
    }];
    [av show];
}
@end
