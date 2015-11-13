//
//  AppDelegate.m
//  guyizu
//
//  Created by 蓝叶软件 on 11/21/13.
//  Copyright (c) 2013 蓝叶软件. All rights reserved.
//

#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "UserGuideViewController.h"
#import "LeveyTabBarController.h"

@interface AppDelegate ()

@property Reachability *internetReachability;

@end

@implementation AppDelegate

@synthesize leveyTabBarController = _leveyTabBarController;
@synthesize nav = _nav;
@synthesize isIphone4 = _isIphone4;
@synthesize isIos6 = _isIos6;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    [NSThread sleepForTimeInterval:3];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    self.window.backgroundColor = [UIColor colorWithRed:0/255.0 green:160/255.0 blue:211/255.0 alpha:1.0];
    
    //isIphone4
    if ([UIScreen mainScreen].bounds.size.height < 481 ) {
        _isIphone4 = YES;
    }else{
        _isIphone4 = NO;
    }
    //isIos6
    if ([[[UIDevice currentDevice] systemVersion]intValue] > 6.999 ) {
        _isIos6 = NO;
    }else{
        _isIos6 = YES;
    }

    //设定是否登陆
    [[NSUserDefaults standardUserDefaults] setBool: NO forKey:@"islogin"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"uid"];
    
    
    HomePageViewController *homeCtl = [[HomePageViewController alloc]initWithNibName:@"HomePageViewController" bundle:nil];
    _nav = [[UINavigationController alloc] initWithRootViewController:homeCtl];
    if (_isIos6) {
        [_nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"123.png"] forBarMetrics:UIBarMetricsDefault];
    }else{
        [_nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"111.png"] forBarMetrics:UIBarMetricsDefault];
    }
    
    
    
    //是否第一次登录
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
    
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        UserGuideViewController *userCtl = [[UserGuideViewController alloc] init];
        self.window.rootViewController = userCtl;
    }
    else{

        self.window.rootViewController = _nav;
    }
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self updateInterfaceWithReachability:self.internetReachability];
    
    
//    NSString *testStr = @"http://www.guyizu.com/item.php?act=subject&meth=addpic&format=png";
//    UIImage *image = [UIImage imageNamed:@"test.png"];
//    NSData *mData = UIImagePNGRepresentation(image);
//    LHYHTTPRequest *lhy = [[LHYHTTPRequest alloc]initWith:testStr andHttpbody:mData];
//    lhy.delegate = self;

    
    return YES;
}




- (void) reachabilityChanged:(NSNotification *)note
{
    NSLog(@"%@ \n %@", note.object, note.userInfo);
}


- (void)updateInterfaceWithReachability:(Reachability *)reachability
{
    NSLog(@"%@", reachability  );
}


- (void)configureTextField:(UITextField *)textField imageView:(UIImageView *)imageView reachability:(Reachability *)reachability
{
    
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
