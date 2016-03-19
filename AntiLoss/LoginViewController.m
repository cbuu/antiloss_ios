//
//  ViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/11/16.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "LoginViewController.h"
#import "network/networkCenter.h"

#import "AntilossViewController.h"
#import "RegisterViewController.h"
#import "AntilossHelpViewController.h"
#import <BmobSDK/Bmob.h>
#import "manager/WXApiManager.h"
#import "AntilLossListViewController.h"
#import "WXApiObject.h"
#import "JSONParseUtil.h"
#import "UserManager.h"
#import "BTManager.h"

@interface LoginViewController ()<LoginDelegate,WXApiManagerDelegate>{
    NetworkCenter * networkCenter;
}

@end

@implementation LoginViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkCenter getInstance].loginDelegate = self;
    
    [[NetworkCenter getInstance] login:@"cbuu" password:@"123"];
    
    if ([UserManager getInstance].mode == USER_MODE) {
        [WXApiManager sharedManager].delegate = self;
    }
}

#pragma mark action

- (IBAction)loginClick:(id)sender {
    
    NSLog(@"begin login");
    
    NSString * username = self.usernameTextField.text;
    NSString * password = self.passwordTextField.text;
    
    if (username.length>0&&password.length>0) {
        [[NetworkCenter getInstance] login:username password:password];
    }
    else{
        NSLog(@"username or password is empty!");
    }
}

- (IBAction)registerClick:(id)sender {
    NSLog(@"jump to Register");
    
    [self performSegueWithIdentifier:@"logintoregister" sender:self];
}


#pragma mark -- networkCenter delegate

- (void)loginResult:(BOOL)isSuccess withData:(NSDictionary *)data
{
    if (isSuccess) {
        [[UserManager getInstance] setUpUserWithData:data];
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"登陆成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if ([UserManager getInstance].mode == HELP_MODE) {
                if (nil != [WXApiManager sharedManager].cache) {
                    [self performSegueWithIdentifier:@"toHelpController" sender:self];
                }
            }else{
                [self performSegueWithIdentifier:@"toAntilossTableViewController" sender:self];
            }
        }];
        [alertController addAction:alertAction];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
    else{
        NSLog(@"login fail");
        //TODO
    }
}

#pragma mark -- wxapimanager delegate

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request {
    
    WXMediaMessage * message = request.message;
    WXAppExtendObject * obj = message.mediaObject;
    NSString * deviceJson = obj.extInfo;
    NSData * data = obj.fileData;
    NSDictionary * deviceInfo = [JSONParseUtil deviceFromJson:deviceJson];
    NSDictionary * userInfo   = [JSONParseUtil userFromJSON:data];
    OpenCache * cache = [[OpenCache alloc]init];
    cache.deviceName = deviceInfo[@"deviceName"];
    cache.deviceMac = deviceInfo[@"deviceMac"];
    cache.imageID = deviceInfo[@"image"];
    cache.teleNum = userInfo[@"teleNum"];
    [WXApiManager sharedManager].cache = cache;
    [UserManager getInstance].mode = HELP_MODE;

    [self performSegueWithIdentifier:@"toHelpController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toHelpController"]) {
        OpenCache * cache = [WXApiManager sharedManager].cache;
        AntilossHelpViewController * avc = segue.destinationViewController;
        AntiLossDevice * device = [[AntiLossDevice alloc] init];
        device.deviceMac = cache.deviceMac;
        device.imageID = cache.imageID;
        device.deviceName = cache.deviceName;
        avc.device = device;
        avc.teleNum = cache.teleNum;
    }
}



@end
