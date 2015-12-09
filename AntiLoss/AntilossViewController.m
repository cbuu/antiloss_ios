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
#import <UIKit/UIKit.h>
@interface AntilossViewController ()<BTManagerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    CBUURotateView * rotateView;
    UIImagePickerController * imagePickerController;
    UIAlertController * alertController;
    BOOL isFound;
}

@end

@implementation AntilossViewController

- (void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [BTManager getInstance].managerDelegate = self;
    
    isFound = NO;
    
    [self initView];
    
    [[BTManager getInstance] scan];
}

- (void)initView{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f]];
    
    self.searchStateLabel.text = @"搜索中";
    
    self.deviceNameLabel.text = self.device.deviceName;
    
    [self makeRoundImage:self.deviceImage];
    
    [self addRotateView];
    
    [self initDeviceNameLabel];
    [self initPickerController];
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
        NSLog(@"%@",nameField.text);
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

- (IBAction)soundButtonClick:(id)sender {
    NSLog(@"sound");
    [[BTManager getInstance] makeSound:self.device];
}
- (IBAction)editDeviceInfo:(id)sender {
    
}

@end
