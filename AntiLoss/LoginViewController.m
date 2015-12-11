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
#import <BmobSDK/Bmob.h>
#import "manager/WXApiManager.h"
#import "AntilLossListViewController.h"
#import "WXApiObject.h"
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
    
    NSLog(@"login");
    
    NSString * username = self.usernameTextField.text;
    NSString * password = self.passwordTextField.text;
    
    if (username.length>0&&password.length>0) {
        [[NetworkCenter getInstance] login:username password:password];
    }
}

- (IBAction)registerClick:(id)sender {
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
                    [self performSegueWithIdentifier:@"toHelpViewController" sender:self];
                }
            }else{
                [self performSegueWithIdentifier:@"toAntilossTableViewController" sender:self];
            }
        }];
        [alertController addAction:alertAction];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
    else{
        NSLog(@"fail");
    }
}

#pragma mark -- wxapimanager delegate

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request {
    
    WXMediaMessage * message = request.message;
    WXAppExtendObject * obj = message.mediaObject;
    NSString * username = message.messageExt;
    NSString * deviceMac = obj.extInfo;
    OpenCache * cache = [OpenCache new];
    cache.username = username;
    cache.deviceMac = deviceMac;
    [WXApiManager sharedManager].cache = cache;
    [UserManager getInstance].mode = HELP_MODE;

    [self performSegueWithIdentifier:@"toHelpViewController" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toHelpViewController"]) {
        OpenCache * cache = [WXApiManager sharedManager].cache;
        AntilossViewController * avc = segue.destinationViewController;
        AntiLossDevice * device = [[AntiLossDevice alloc] init];
        device.deviceMac = cache.deviceMac;
        avc.device = device;
    }
}



@end
