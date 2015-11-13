//
//  ErshouViewController.m
//  Test-ershouji
//
//  Created by lanye on 13-11-29.
//  Copyright (c) 2013年 lanyes. All rights reserved.
//

#import "ErshouViewController.h"
#import "DengluViewController.h"
#import "DownloadMessageAndReward.h"

@interface ErshouViewController ()

@end

@implementation ErshouViewController
@synthesize backscroll=_backscroll,titlescroll=_titlescroll,gerenbutton=_gerenbutton,shangjiabutton=_shangjiabutton,
biaotitextfield=_biaotitextfield,numbertextfield=_numbertextfield,textviewlable=_textviewlable,miaoshutextview=_miaoshutextview,backview=_backview;
@synthesize passStr = _passStr;
@synthesize leftpasstr = _leftpasstr;
@synthesize rightpasstr = _rightpasstr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.assets = [[NSMutableArray alloc] initWithCapacity:10];
        _imagearry = [[NSMutableArray alloc]initWithCapacity:10];
        _passStr = [[NSMutableString alloc]initWithCapacity:0];
        _leftpasstr = [[NSMutableString alloc]init];
        _rightpasstr = [[NSMutableString alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fenleifabuOver) name:@"fenleifabuOver" object:nil];
    
    _backview.layer.borderWidth = 0.5f;
    _backview.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _backscroll.contentSize = CGSizeMake(320, 760);
    _titlescroll.contentSize = CGSizeMake(640, 100);
    
    UIButton *fabubutton = [[UIButton alloc]initWithFrame:CGRectMake(15, 490, 290, 40)];
    [fabubutton setTitle:@"发 布" forState:UIControlStateNormal];
    [fabubutton setTintColor:[UIColor whiteColor]];
    [fabubutton addTarget:self action:@selector(fabu) forControlEvents:UIControlEventTouchUpInside];
    [fabubutton setBackgroundColor:[UIColor colorWithRed:0 green:160/255.0 blue:211/255.0 alpha:1]];
    [_backscroll addSubview:fabubutton];
    
    //构建nav
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setBackgroundImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    leftbutton.frame = CGRectMake(0, 0, 11, 20);
    [leftbutton addTarget:self action:@selector(mleftBarBttonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbutton];
    
    UILabel *customLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    customLab.backgroundColor = [UIColor clearColor];
    [customLab setTextColor:[UIColor whiteColor]];
    [customLab setText:@"二手手机"];
    [customLab setTextAlignment:NSTextAlignmentCenter];
    customLab.font = [UIFont boldSystemFontOfSize:20];
    self.navigationItem.titleView = customLab;
    
    
    //拍照
    self.titleImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(img)];
    [self.titleImg addGestureRecognizer:tap];
    
     UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self.titleView addGestureRecognizer:tapView];
    
    
    //类别
    self.clickView.userInteractionEnabled = YES;
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [self.clickView addGestureRecognizer:click];
    
    //身份
    UITapGestureRecognizer *left = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(left)];
    [self.gerrenView addGestureRecognizer:left];
    
    UITapGestureRecognizer *right = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(right)];
    [self.shangjiaView addGestureRecognizer:right];
    
    [_gerenbutton setBackgroundImage:[UIImage imageNamed:@"life_select_click.png"] forState:UIControlStateNormal]; //默认选择个人
    
    //手机键盘
    _numbertextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.pricetextfield.keyboardType = UIKeyboardTypeNumberPad;
    
    //分类传值过来
   self.cilckLab.text = _passStr;
   
    
}

-(void)mleftBarBttonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark DownloadOver

-(void)fenleifabuOver{
    NSMutableDictionary *mDic = [DownloadMessageAndReward shareDownload].passDic;
    NSString *str = [[mDic objectForKey:@"data"] objectForKey:@"msg"];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark -

-(void)fabu
{
    BOOL islog = [[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"];
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];

    if (islog) {
        if ([self.pricetextfield.text isEqualToString:@""] || [self.biaotitextfield.text isEqualToString:@""] || [self.numbertextfield.text isEqualToString:@""] || [self.miaoshutextview.text isEqualToString:@""]) {

            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请输入完整文字" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }else if (![phoneTest evaluateWithObject:_numbertextfield.text]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请输入正确手机号格式" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }else{
            [self sendRequeast];
        }
        
    }else{
        DengluViewController *denglu = [[DengluViewController alloc]initWithNibName:@"DengluViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:denglu];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

-(void)sendRequeast{
    //发送请求,在这里拼接URL字符串，然后发送请求
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    [[DownloadMessageAndReward shareDownload] startDownload:str mid:1 fatherID:_leftpasstr sonID:_rightpasstr lng:102.03310 lat:25.12680 name:self.biaotitextfield.text price:self.pricetextfield.text content:self.miaoshutextview.text phoneNum:self.numbertextfield.text fnishTime:nil];
    
}

#pragma mark -

-(void)textFieldDidBeginEditing:(UITextField *)textField{   //开始编辑时，整体上移
    if (textField.tag==12) {
        //[_backscroll scrollRectToVisible:CGRectMake(0, 120, 320, _backscroll.frame.size.height) animated:YES];
        [self moveView:-50];
    }
    if (textField.tag ==13 ) {
        [self moveView:-90];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{     //结束编辑时，整体下移
    
    if (textField.tag==12) {
        [self moveView:50];
    }
    if (textField.tag == 13) {
        [self moveView:90];
    }
    
}
-(void)moveView:(float)move{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y +=move;//view的y轴上移
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];//设置调整界面的动画效果
}

#pragma mark uitextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    [_textviewlable removeFromSuperview];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_miaoshutextview resignFirstResponder];
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_biaotitextfield resignFirstResponder];
    [_numbertextfield resignFirstResponder];
    [self.pricetextfield resignFirstResponder];
    [self.lianxiren resignFirstResponder];
    return YES;
}




//控制身份的转换
-(void)left
{
    [_gerenbutton setBackgroundImage:[UIImage imageNamed:@"life_select_click.png"] forState:UIControlStateNormal];
    [_shangjiabutton setBackgroundImage:[UIImage imageNamed:@"life_select.png"] forState:UIControlStateNormal];
}

-(void)right
{
    [_shangjiabutton setBackgroundImage:[UIImage imageNamed:@"life_select_click.png"] forState:UIControlStateNormal];
    [_gerenbutton setBackgroundImage:[UIImage imageNamed:@"life_select.png"] forState:UIControlStateNormal];
}

//调用照相机
-(void)img {
    
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [mySheet showInView:self.view];
}
-(void)tapView
{
    UIActionSheet* mySheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消"destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    [mySheet showInView:self.view];
}


//选择类别
-(void)click
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)keyboard:(id)sender {
    [_biaotitextfield resignFirstResponder];
    [_numbertextfield resignFirstResponder];
    [_numbertextfield resignFirstResponder];
    [_miaoshutextview resignFirstResponder];
    [self.lianxiren resignFirstResponder];
     [self.pricetextfield resignFirstResponder];
}

//选择照相，或者照片库
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == 0) {
        
        [self.addpiclable removeFromSuperview];
        UIImagePickerController *pick = [[UIImagePickerController alloc]init];
        pick.delegate = self;
        pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        pick.allowsEditing = YES;
        [self presentViewController:pick animated:YES completion:NULL];
    }
    if (buttonIndex == 1) {
        [self.addpiclable removeFromSuperview];
        
        CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
        picker.maximumNumberOfSelection = 10;
        picker.assetsFilter = [ALAssetsFilter allAssets];
        picker.delegate = self;
        
     
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL iscamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
    if (!iscamera) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"没有相机" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake(110, 10, 90, 80)];
        imageview.image = img;
        [self.titlescroll addSubview:imageview];
    
}
-(void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    [self.assets removeAllObjects];
    for (UIImageView *thisView in _imagearry) {
        [thisView removeFromSuperview];
    }
    
    //问题出在这里
    for (UIImageView *thisView in _imagearry) {
        [thisView removeFromSuperview];
    }
    [_imagearry removeAllObjects];

    [self.assets addObjectsFromArray:assets];
    for (i = 0; i<self.assets.count; i++) {
        imageview = [[UIImageView alloc]initWithFrame:CGRectMake((110+105*i), 10, 90, 80)];
         imageview.userInteractionEnabled = YES;
        ALAsset *asset = [self.assets objectAtIndex:i];
        imageview.image = [UIImage imageWithCGImage:asset.thumbnail];
        button = [[UIButton alloc]initWithFrame:CGRectMake(61, 71, 29, 9)];
        button.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"member_r28_c21.png"]];
        button.tag = i + 200;
        [button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        [imageview addSubview:button];
        [_imagearry addObject:imageview];
        [_titlescroll addSubview:imageview];
    }
}

-(void)change:(UIButton *)mButton
{
//    NSLog(@"%@",_imagearry);
    
    UIImageView *thisimageview = [_imagearry objectAtIndex:mButton.tag - 200];
    [thisimageview removeFromSuperview];
    
}


@end
