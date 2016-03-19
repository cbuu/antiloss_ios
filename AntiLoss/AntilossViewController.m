//
//  AntilossViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/11/25.
//  Copyright © 2015年 cbuu. All rights reserved.
//
#import "AntiLossDevice.h"
#import "AntilossViewController.h"
#import "CBUURotateView.h"
#import "manager/BTManager.h"
#import "WXApiManager.h"
#import "Utils.h"
#import "NetworkCenter.h"
#import "manager/UserManager.h"
#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "manager/UserManager.h"
#import "JSONParseUtil.h"
#import "IOIndicatorView.h"
@interface AntilossViewController ()<
BTManagerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UpdateDeviceDelegate,
ImageLoaderDelegate,
WXApiManagerDelegate>
{
    CBUURotateView * rotateView;
    UIImagePickerController * imagePickerController;
    UIAlertController * alertController;
    //UIActivityIndicatorView * indicatorView;
    IOIndicatorView * indicatorView;
    BOOL isFound;
    NSString * imageNetPath;
}

@end

@implementation AntilossViewController

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    if (isFound) {
        [rotateView stopRotate];
    }else{
        [rotateView startRotateWithDuration:2.0f];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [rotateView stopRotate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BTManager getInstance].managerDelegate = self;
    [NetworkCenter getInstance].imageLoader.delegate = self;
    [NetworkCenter getInstance].updateDeviceDelegate = self;
    isFound = NO;
    
    [self initView];
    
    [[BTManager getInstance] scan];
    [[NetworkCenter getInstance].imageLoader downloadImage:self.device.imageID];
    
}

-(void)dealloc{
    [[BTManager getInstance] disconnectAllDevices];
}

- (void)initView{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.0f]];
    
    self.searchStateLabel.text = @"搜索中...";
    
    self.deviceNameLabel.text = self.device.deviceName;
    
    self.title = @"寻找设备";
    
    [self makeRoundImage:self.deviceImage];
    
    [self initButton];
    
    [self addRotateView];
    
    [self initDeviceNameLabel];
    
    [self initPickerController];
}

- (void)initButton{
    [Utils makeRoundButton:self.soundButton];
}

- (void)initDeviceNameLabel{
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editNameClick)];
    self.deviceNameLabel.userInteractionEnabled = YES;
    [self.deviceNameLabel addGestureRecognizer:recognizer];
}

- (void)addRotateView{
    rotateView = [CBUURotateView buildProgressViewWithFrame:self.deviceImage.frame redius:self.deviceImage.frame.size.width/2 width:5 startAngle:0 endAngle:M_PI/2 color:[UIColor greenColor]];
    rotateView.userInteractionEnabled = NO;
    rotateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:rotateView];
    
    NSLayoutConstraint * rotateViewConstraintX = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.deviceImage attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0];
    NSLayoutConstraint * rotateViewConstraintY = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.deviceImage attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    
    NSLayoutConstraint * rotateViewConstraintW = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.deviceImage attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
    
    NSLayoutConstraint * rotateViewConstraintH = [NSLayoutConstraint constraintWithItem:rotateView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.deviceImage attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
    
    rotateViewConstraintX.active = YES;
    rotateViewConstraintY.active = YES;
    rotateViewConstraintW.active = YES;
    rotateViewConstraintH.active = YES;
    
    [rotateView startRotateWithDuration:2.0f];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)makeRoundImage:(UIImageView*)imageView{
    imageView.layer.cornerRadius = imageView.frame.size.width/2;
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.borderWidth = 5.0f;
    
    UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editImageClick)];
    imageView.userInteractionEnabled = YES;
    
    [imageView addGestureRecognizer:recognizer];
}

- (void)initPickerController
{
    imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void)appWillEnterForegroundNotification{
    if (!isFound) {
        [rotateView startRotateWithDuration:2.0f];
    }
}

#pragma mark - BTmanager delegate

- (void)deviceFound:(AntiLossDevice *)device
{
    if (device&&[device.deviceMac isEqualToString:self.device.deviceMac]) {
        [[BTManager getInstance] connect:device];
    }
}

- (void)deviceConnectResult:(BOOL)isSuccess
{
    isFound = isSuccess;
    if (isSuccess) {
        self.searchStateLabel.text = @"已找到";
        [self.soundButton setTitle:@"鸣笛" forState:UIControlStateNormal];
        [rotateView stopRotate];
    }
}

- (void)deviceDisconnectResult:(BOOL)isSuccess
{
    if (isSuccess) {
        isFound = NO;
        [indicatorView hide];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - imageLoader delegate

- (void)onUploadImage:(NSString *)urlStr
{
    if (nil == urlStr) {
        return ;
    }
    NSLog(@"%@",urlStr);
    
    imageNetPath= urlStr;
    
    [[NetworkCenter getInstance] uploadDeviceInfoWithMac:self.device.deviceMac deviceName:self.deviceNameLabel.text andImagePath:urlStr];
}

- (void)onDownloadImage:(UIImage *)image
{
    if (image) {
        self.deviceImage.image = image;
        self.device.image = image;
    }
}

- (void)updateDeviceResult:(BOOL)isSuccees
{
    if (isSuccees) {
        [indicatorView hide];
        
        self.device.deviceName = self.deviceNameLabel.text;
        self.device.image = self.deviceImage.image;
        self.device.imageID = imageNetPath;
        
        alertController = [UIAlertController alertControllerWithTitle:@"上传成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];

    }
}

#pragma mark - pickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"get image %@  ---  %@",info[UIImagePickerControllerMediaURL],info[UIImagePickerControllerReferenceURL]);
    UIImage * image = info[UIImagePickerControllerEditedImage];
    self.deviceImage.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - click Action

- (void)editNameClick{
    NSLog(@"editNameClick");
    alertController = [UIAlertController alertControllerWithTitle:@"修改设备名字" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"设备名字";
    }];
    
    UIAlertAction * editView = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * nameField = alertController.textFields.firstObject;
        if (nameField.text.length>0) {
            self.deviceNameLabel.text = nameField.text;
        }
    }];
    
    UIAlertAction * cancel  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:editView];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)editImageClick
{
    NSLog(@"editImageClick");
    alertController = [UIAlertController alertControllerWithTitle:@"选择方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"图片库" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    
    UIAlertAction * cancle  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:cancle];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)soundOrHelpButtonClick:(id)sender {
    if (isFound) {
        NSLog(@"sound");
        [[BTManager getInstance] makeSound:self.device];
    }else{
        alertController = [UIAlertController alertControllerWithTitle:@"求助描述" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入寻物启事描述";
        }];
        
        
        UIAlertAction * editView = [UIAlertAction actionWithTitle:@"下一步" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField * nameField = alertController.textFields.firstObject;
            if (nameField.text.length>0) {
                User * user = [UserManager getInstance].user;
                NSData * data = [JSONParseUtil userToJSON:user];
                [[WXApiManager sharedManager] sendMessageWithTitle:@"帮人家找找嘛～" device:self.device deviceImage:self.deviceImage.image Desciption:nameField.text andData:data];
            }
        }];
                                    
        
        UIAlertAction * cancel  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:editView];
        [alertController addAction:cancel];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
}
- (IBAction)saveDeviceInfoButtonClick:(id)sender {
    indicatorView = [[IOIndicatorView alloc] init];
    [indicatorView show];
    
    [[NetworkCenter getInstance].imageLoader uploadImage:self.deviceImage.image];
}

- (IBAction)backButtonClick:(id)sender {
    if (isFound) {
        [[BTManager getInstance] disconnectAllDevices];
        
        indicatorView = [[IOIndicatorView alloc] init];
        [indicatorView show];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
