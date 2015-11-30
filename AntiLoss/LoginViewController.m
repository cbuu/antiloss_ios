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

#import "BTManager.h"

@interface LoginViewController ()<LoginDelegate,WXApiManagerDelegate>{
    UIButton * button_login;
    UIButton * button_register;
    
    UILabel * label_username;
    UILabel * label_password;
    
    UITextField * field_username;
    UITextField * field_password;
    
    NetworkCenter * networkCenter;
}

@end

@implementation LoginViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"登陆"];
    
    [self initView];
    
    [WXApiManager sharedManager].delegate = self;
}

- (void)initView{
    field_username = [[UITextField alloc] initWithFrame:CGRectMake(100,250, 200, 50)];
    field_password = [[UITextField alloc] initWithFrame:CGRectMake(100, 320, 200, 50)];
    
    field_username.borderStyle = UITextBorderStyleRoundedRect;
    field_password.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:field_username];
    [self.view addSubview:field_password];
    
    button_login = [UIButton buttonWithType:UIButtonTypeSystem];
    [button_login setTitle:@"登陆" forState:UIControlStateNormal];
    button_login.frame = CGRectMake(100, 400, 80, 50);
    button_login.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [button_login addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button_login];
    
    button_register = [UIButton buttonWithType:UIButtonTypeSystem];
    [button_register setTitle:@"注册" forState:UIControlStateNormal];
    button_register.frame = CGRectMake(220, 400, 80, 50);
    button_register.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [button_register addTarget:self action:@selector(signUpClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button_register];

    
    [NetworkCenter getInstance].loginDelegate = self;
}


#pragma mark -- action

- (void)loginClick
{
    AntilLossListViewController * vc = [[AntilLossListViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:TRUE];
    
    
    //[[BTManager getInstance] scan];
    
//    NSString * username = field_username.text;
//    NSString * password = field_password.text;
//    
//    NSLog(@"%@  %@",username ,password);
//    
//    NSLog(@"begin to login");
//    
//    [[NetworkCenter getInstance] login:username password:password];
    
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

}

- (void)signUpClick
{
    
    
    //UIViewController *vc = [RegisterViewController new];
    //[self.navigationController pushViewController:vc animated:TRUE];
}



#pragma mark -- networkCenter delegate

- (void)loginResult:(BOOL)isSuccess
{
    if (isSuccess) {
        NSLog(@"succeed");
    }
    else{
        NSLog(@"fail");
    }
}

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


@end
