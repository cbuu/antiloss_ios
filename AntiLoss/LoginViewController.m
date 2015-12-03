//
//  ViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/11/16.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "LoginViewController.h"
#import "network/networkCenter.h"
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
    
    
    [WXApiManager sharedManager].delegate = self;
    [NetworkCenter getInstance].loginDelegate = self;
}

//    UIImage * thumbImage = [UIImage imageNamed:@"Icon-40.png"];
//    
//    WXAppExtendObject * obj = [WXAppExtendObject object];
//    obj.extInfo = @"mac";
//    obj.fileData = UIImageJPEGRepresentation(thumbImage, 1.0);
//    
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = @"title";
//    message.mediaObject = obj;
//    message.description = @"antiloss";
//    
//    [message setThumbImage:thumbImage];
//    
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    
//    req.message = message;
//    req.scene = WXSceneSession;
//    req.bText = NO;
//    
//    BOOL s = [WXApi sendReq:req];
//    if (s) {
//        NSLog(@"yes");
//    }else{
//        NSLog(@"no");
//    }





#pragma mark -- wxapimanager delegate

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)req {
    WXMediaMessage *msg = req.message;
    
    //显示微信传过来的内容
    WXAppExtendObject *obj = msg.mediaObject;
    
    NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
    NSString *strMsg = [NSString stringWithFormat:@"openID: %@, 标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n附加消息:%@\n", req.openID, msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length, msg.messageExt];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
                                                    message:strMsg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil, nil];
    [alert show];
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
        NSLog(@"succeed");
        
        [[UserManager getInstance] setUpUserWithData:data];
        
        [self performSegueWithIdentifier:@"toAntilossTableViewController" sender:self];
    }
    else{
        NSLog(@"fail");
    }
}

@end
