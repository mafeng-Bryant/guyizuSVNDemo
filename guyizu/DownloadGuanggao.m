//
//  DownloadGuanggao.m
//  guyizu
//
//  Created by Mac mini on 13-12-11.
//  Copyright (c) 2013年 蓝叶软件. All rights reserved.
//

#import "DownloadGuanggao.h"

#define HTTP_URL @"http://www.guyizu.com/member.php?act=login_in&meth=queryAdv"
#define HTTP_HEAD @"http://www.guyizu.com"

@implementation DownloadGuanggao

@synthesize passImageStrArry = _passImageStrArry;


#pragma mark -
- (id)init
{
    self = [super init];
    if (self) {
        _passImageStrArry = [[NSMutableArray alloc]initWithCapacity:6];
        
    }
    return self;
}


#pragma mark xiazai
DownloadGuanggao *guanggaoDownload = nil;
+(DownloadGuanggao *)shareDownload{
    
    if (guanggaoDownload == nil) {
        guanggaoDownload = [[DownloadGuanggao alloc]init];
        [guanggaoDownload startDown];
    }
    return  guanggaoDownload;
    
}

-(void)startDown{
    
     LHYHTTPRequest *guanggao = [[LHYHTTPRequest alloc]initWith:HTTP_URL];
    guanggao.delegate = self;
  
}

-(void)returnJsonDic:(id)send And:(id)mLHYHTTPRequest{
    
    [_passImageStrArry removeAllObjects];
    
    NSArray *arr1 = [[send objectForKey:@"data"] objectForKey:@"path"];
    
    for (NSString* s in arr1) {
        
        NSLog(@"%@",s);
        
        
    }
    
    
    for (NSString *str in arr1) {
        NSString *str2 = [HTTP_HEAD stringByAppendingString:str];
        
        NSLog(@"str =%@",str);
        NSLog(@"str =%@",str2);

        
      //  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str2]];
     //   UIImage *image = [UIImage imageWithData:data];
        
        
        
        [_passImageStrArry addObject:str2];
    }
    
    NSLog(@"%d",_passImageStrArry.count);
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"guanggaoDownloadOver" object:nil];
}


@end
