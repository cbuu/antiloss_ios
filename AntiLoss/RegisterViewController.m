//
//  RegisterViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/11/21.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "RegisterViewController.h"
#import "network/NetworkCenter.h"

@interface RegisterViewController ()<SignUpDelegate>
{
    UIButton * button_signUp;
    UIButton * button_cancel;
    
    UILabel * label_username;
    UILabel * label_password;
    
    UITextField * field_username;
    UITextField * field_password;
    
    NetworkCenter * networkCenter;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"注册"];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView{
    field_username = [[UITextField alloc] initWithFrame:CGRectMake(100,250, 200, 50)];
    field_password = [[UITextField alloc] initWithFrame:CGRectMake(100, 320, 200, 50)];
    
    field_username.borderStyle = UITextBorderStyleRoundedRect;
    field_password.borderStyle = UITextBorderStyleRoundedRect;
    
    [self.view addSubview:field_username];
    [self.view addSubview:field_password];
    
    button_signUp = [UIButton buttonWithType:UIButtonTypeSystem];
    [button_signUp setTitle:@"注册" forState:UIControlStateNormal];
    button_signUp.frame = CGRectMake(100, 400, 80, 50);
    button_signUp.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [button_signUp addTarget:self action:@selector(signUpClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button_signUp];
    
    [NetworkCenter getInstance].signUpDelegate = self;
}


#pragma mark action

- (void)signUpClick
{
    NSString * username = field_username.text;
    NSString * password = field_password.text;
    
    NSLog(@"%@  %@",username ,password);
    
    NSLog(@"begin to signUp");
    
    [[NetworkCenter getInstance] signUp:username password:password];

}

#pragma mark delegate

- (void)signUpResult:(BOOL)isSuccess
{
    if (isSuccess) {
        NSLog(@"succeed");
    }
    else{
        NSLog(@"fail");
    }
}

@end
