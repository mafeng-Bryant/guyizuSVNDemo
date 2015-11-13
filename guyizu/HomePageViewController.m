//
//  HomePageViewController.m
//  guyizu
//
//  Created by 蓝叶软件 on 11/21/13.
//  Copyright (c) 2013 蓝叶软件. All rights reserved.
//

#import "HomePageViewController.h"
#import "OtherViewController.h"
#import "CityListViewController.h"
#import "FenleiViewController.h"
#import "AppDelegate.h"
#import "LifeFirstViewController.h"
#import "ReWardFirstViewController.h"
#import "DengluViewController.h"
#import "ShakeViewController.h"
#import "UserViewController.h"
#import "DengluViewController.h"
#import "CityListTwoViewController.h"
#import "DownloadGuanggao.h"
#import "UIImageView+WebCache.h"
#import "PlaneDynamicViewController.h"
#import "ListViewController.h"
#define HTTP_URL @"http://www.guyizu.com/member.php?act=login_in&meth=get_city"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

@synthesize cityName = _cityName;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 60, 40)];
        leftView.backgroundColor = [UIColor clearColor];
        
        
        _mlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        _mlabel.backgroundColor = [UIColor clearColor];
        _mlabel.textColor = [UIColor whiteColor];
        [leftView addSubview:_mlabel];
        
        UIImageView *downImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"index_down.png"]];
        downImage.frame = CGRectMake(42, 17, 13, 8);
        [leftView addSubview:downImage];
        
        UITapGestureRecognizer *mCityTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(citychooseButton)];
        [leftView addGestureRecognizer:mCityTap];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    }
    return self;

}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    
    if (_cityName == nil) {
        
        _mlabel.text = @"城市";
    }else{
        NSString *str = [_cityName substringToIndex:2];
        _mlabel.text = str;
    }
    search.hidden = NO;
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化广告
    [self initWithUpScrollView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadOverGuanggao) name:@"guanggaoDownloadOver" object:nil];
    [DownloadGuanggao shareDownload];

    self.view.userInteractionEnabled=YES;

    //搜索栏
    search = [[UISearchBar alloc]initWithFrame:CGRectMake(80, 0, 240, 44)];
    search.delegate = self;
    search.placeholder = @" 请输入商户名、地点";
    [self.navigationController.navigationBar addSubview:search];


    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:152/255.0 blue:224/255.0 alpha:1.0];
    
    self.lifeImageView.userInteractionEnabled = YES;
    self.plainImageView.userInteractionEnabled = YES;
    self.trainImageVIew.userInteractionEnabled = YES;
    self.missonImageView.userInteractionEnabled = YES;
    self.memberImageView.userInteractionEnabled = YES;
    self.stionImageView.userInteractionEnabled = YES;
    self.searchImageView.userInteractionEnabled = YES;
    self.shakImageView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *lifeTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lifechooseButton)];
    UITapGestureRecognizer *tapGest2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(planefindButton)];
    UITapGestureRecognizer *tapGest3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeViewCtl)];
    UITapGestureRecognizer *tapGest4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rewardChooseButton)];
    UITapGestureRecognizer *tapGest5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(memeberCenterChooseButton)];
    UITapGestureRecognizer *tapGest6 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeViewCtl)];
    UITapGestureRecognizer *tapGest7 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeViewCtl)];
    UITapGestureRecognizer *tapGest8 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shakeChooseButton)];
    UITapGestureRecognizer* tapGest9=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OtherViewaction)];
    [self.OtherVIew addGestureRecognizer:tapGest9];
    
    [self.lifeImageView addGestureRecognizer:lifeTap];
    [self.plainImageView addGestureRecognizer:tapGest2];
    [self.trainImageVIew addGestureRecognizer:tapGest3];
    [self.missonImageView addGestureRecognizer:tapGest4];
    [self.memberImageView addGestureRecognizer:tapGest5];
    [self.stionImageView addGestureRecognizer:tapGest6];
    [self.searchImageView addGestureRecognizer:tapGest7];
    [self.shakImageView addGestureRecognizer:tapGest8];
    
    
    //ios6
    AppDelegate *homeApp = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (homeApp.isIos6) {
        
        [[search.subviews firstObject] removeFromSuperview];
    }
    
    [self locationInphone];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    search.hidden = YES;
}

#pragma mark -

#pragma mark DownloadOver

-(void)downloadOverGuanggao{
    
    [slideImages setArray: [DownloadGuanggao shareDownload].passImageStrArry];
   
    [self mAddImage];
}

#pragma mark Location

-(void)locationInphone{
    if ([CLLocationManager locationServicesEnabled]) {//判断手机是否可以定位
        _locationManager = [[CLLocationManager alloc] init];//初始化位置管理器
        [_locationManager setDelegate:self];
//        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//设置精度
//        _locationManager.distanceFilter = 1000.0f;//设置距离筛选器
        [_locationManager startUpdatingLocation];//启动位置管理器
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法定位" message:@"请在设置－隐私中打开定位服务" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark  CLLocationManager Delegate
int jsonCount = 0;
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    NSLog(@"%@",[locations lastObject]);
    
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    CGFloat mLatitude = coor.latitude;
    CGFloat mLongitude = coor.longitude;
    
    if (jsonCount == 0) {
        [self startRequeast:mLongitude And:mLatitude];
        ++jsonCount;
    }

    [_locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"定位失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
-(void)OtherViewaction
{
    ListViewController* vc=[ListViewController new];
    vc.ishometolistview=YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark HTTPDownload

//经纬度
-(void)startRequeast:(CGFloat)longitude And:(CGFloat)latitude{
//    NSString *httpStr = [HTTP_URL stringByAppendingFormat:@"&lng=%f&lat=%f", longitude, latitude];
//    LHYHTTPRequest *sendReaquest = [[LHYHTTPRequest alloc]initWith:httpStr];
//    sendReaquest.delegate = self;
//    NSLog(@"%@",httpStr);
}

//这里会返回城市和城市id
-(void)returnJsonDic:(id)send And:(id)mLHYHTTPRequest{
//    NSLog(@"json return :%@",send);
//    NSDictionary *mDic = [send objectForKey:@"data"];
//    NSLog(@"%@ ,  %@", [mDic objectForKey:@"city"], [mDic objectForKey:@"id"]);

}

#pragma mark ButtonClick
-(void)rewardChooseButton{
    ReWardFirstViewController *rewardFirstCtl = [[ReWardFirstViewController alloc]init];
    
    [self.navigationController pushViewController:rewardFirstCtl animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

-(void)lifechooseButton{
    
    LifeFirstViewController *lifeCtl = [[LifeFirstViewController alloc]init];
    
    [self.navigationController pushViewController:lifeCtl animated:YES];
    self.navigationController.navigationBarHidden = YES;
    
}

-(void)shakeChooseButton{
    ShakeViewController *shakeCtl = [[ShakeViewController alloc]initWithNibName:@"ShakeViewController" bundle:nil];
    [self.navigationController pushViewController:shakeCtl animated:YES];
}

-(void)memeberCenterChooseButton{
    
    BOOL islog = [[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"];

    if (!islog) {
        DengluViewController *dengluCtl = [[DengluViewController alloc]initWithNibName:@"DengluViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:dengluCtl];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
        
        userCtl = [[UserViewController alloc]initWithNibName:@"UserViewController" bundle:nil];
        
        UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftbutton setBackgroundImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
        leftbutton.frame = CGRectMake(0, 0, 11, 20);
        [leftbutton addTarget:self action:@selector(leftReturnClick) forControlEvents:UIControlEventTouchUpInside];
        userCtl.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
        
        [self.navigationController pushViewController:userCtl animated:YES];
    }
    
}

-(void)citychooseButton{
//    CityListViewController *cityCtl = [[CityListViewController alloc]initWithNibName:@"CityListViewController" bundle:nil];
//    cityCtl.passHomePage = self;
//    [self.navigationController pushViewController:cityCtl animated:YES];
    
    CityListTwoViewController *cityTwoCtl = [[CityListTwoViewController alloc]initWithNibName:@"CityListTwoViewController" bundle:nil];
    cityTwoCtl.passHomePage = self;
    [self.navigationController pushViewController:cityTwoCtl animated:YES];
}

-(void)changeViewCtl{
    OtherViewController *otherCtl = [[OtherViewController alloc]init];
    [self.navigationController pushViewController:otherCtl animated:YES];
}
-(void)planefindButton
{
    PlaneDynamicViewController* planedynamic=[[PlaneDynamicViewController alloc] initWithNibName:@"PlaneDynamicViewController" bundle:Nil];
    [self.navigationController pushViewController:planedynamic animated:YES];
}
-(void)leftReturnClick{
    //会员中心返回按钮事件
    [userCtl.navigationController popViewControllerAnimated:YES];
}

#pragma mark scrollView

-(void)initWithUpScrollView{

    // 初始化 scrollview
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 135)];
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    // 初始化 数组 
    slideImages = [[NSMutableArray alloc] init];


}

-(void)mAddImage{
    // 定时器 循环
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
    
    _scrollView.userInteractionEnabled=YES;
    // 初始化 pagecontrol
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(100,106,100,18)]; // 初始化mypagecontrol
    [pageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
    pageControl.userInteractionEnabled=YES;
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    pageControl.numberOfPages = [slideImages count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(turnPage) forControlEvents:UIControlEventValueChanged]; // 触摸mypagecontrol触发change这个方法事件
    [self.view addSubview:pageControl];
    // 创建四个图片 imageview
    for (int i = 0;i<[slideImages count];i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        //网络获取图片
        [imageView setImageWithURL:[NSURL URLWithString:[slideImages objectAtIndex:i]]];
//        NSLog(@"%@",[slideImages objectAtIndex:i]);
        
        imageView.frame = CGRectMake((320 * i) + 320, 0, 320, 135);
        [_scrollView addSubview:imageView]; // 首页是第0页,默认从第1页开始的。所以+320。。。
    }
    // 取数组最后一张图片 放在第0页
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:[slideImages objectAtIndex:([slideImages count]-1)]]];
    imageView.frame = CGRectMake(0, 0, 320, 135); // 添加最后1页在首页 循环
    [_scrollView addSubview:imageView];
    // 取数组第一张图片 放在最后1页
    imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:[slideImages objectAtIndex:0]]];
    imageView.frame = CGRectMake((320 * ([slideImages count] + 1)) , 0, 320, 135); // 添加第1页在最后 循环
    [_scrollView addSubview:imageView];
    
    [_scrollView setContentSize:CGSizeMake(320 * ([slideImages count] + 2), 135)]; //  +上第1页和第4页  原理：4-[1-2-3-4]-1
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    [_scrollView scrollRectToVisible:CGRectMake(320,0,320,135) animated:NO]; // 默认从序号1位置放第1页 ，序号0位置位置放第4页

}

// scrollview 委托函数

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pagewidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pagewidth/([slideImages count]+2))/pagewidth)+1;
    page --;  // 默认从第二页开始
    pageControl.currentPage = page;
}
// scrollview 委托函数

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pagewidth = scrollView.frame.size.width;
    int currentPage = floor((scrollView.contentOffset.x - pagewidth/ ([slideImages count]+2)) / pagewidth) + 1;
    //    int currentPage_ = (int)self.scrollView.contentOffset.x/320; // 和上面两行效果一样
    //    NSLog(@"currentPage_==%d",currentPage_);
    if (currentPage==0)
    {
        [scrollView scrollRectToVisible:CGRectMake(320 * [slideImages count],0,320,135) animated:NO]; // 序号0 最后1页
    }
    else if (currentPage==([slideImages count]+1))
    {
        [scrollView scrollRectToVisible:CGRectMake(320,0,320,135) animated:NO]; // 最后+1,循环第1页
    }
}

// pagecontrol 选择器的方法
- (void)turnPage
{
    int page = pageControl.currentPage; // 获取当前的page
    [_scrollView scrollRectToVisible:CGRectMake(320*(page+1),0,320,135) animated:NO]; // 触摸pagecontroller那个点点 往后翻一页 +1


}
// 定时器 绑定的方法
- (void)runTimePage
{
    int page = pageControl.currentPage; // 获取当前的page
    page++;

    page = page > [slideImages count] - 1 ? 0 : page ;
    pageControl.currentPage = page;
    [self turnPage];

}




#pragma mark -
#pragma mark XLCycleScrollViewDatasource

-(NSInteger)numberOfPages{
    return 6;
}

-(UIView *)pageAtIndex:(NSInteger)index{
//    NSLog(@"%d",index);
    NSString *imageName = [NSString stringWithFormat:@"index_banner0%d.png", index + 1];
    
    if (index > 2) {
        imageName = [NSString stringWithFormat:@"index_banner0%d.png", index - 2];
    }
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];

    // autoSize

    return imageView;
    
}

#pragma mark searchBarDelegate

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.3;
    [self.view addSubview:blackView];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(blackViewClick)];
    [blackView addGestureRecognizer:tapGest];
    
    
    [UIView animateWithDuration:0.3 animations:^(void){
        [search setFrame:CGRectMake(0, search.frame.origin.y, 320, search.frame.size.height)];
    }];
    
    return YES;
}

-(void)blackViewClick{
    [blackView removeFromSuperview];
    blackView = nil;
    
    [UIView animateWithDuration:0.3 animations:^(void){
        [search setFrame:CGRectMake(80, search.frame.origin.y, 240, search.frame.size.height)];
    }completion:^(BOOL finished){
//        [search setFrame:CGRectMake(80, search.frame.origin.y, 240, search.frame.size.height)];
    }];
    
    [search resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
