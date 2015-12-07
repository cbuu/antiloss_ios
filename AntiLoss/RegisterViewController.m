//
//  RegisterViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/11/21.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "RegisterViewController.h"
#import "network/NetworkCenter.h"

#import "AntilossSearchViewController.h"

@interface RegisterViewController ()<SignUpDelegate>
{
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [NetworkCenter getInstance].signUpDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark action
- (IBAction)registerClick:(id)sender {
    NSLog(@"register");
    
    NSString * username = self.usernameTextField.text;
    NSString * password = self.passwordTextField.text;
    
    if (username.length>0&&password.length>0) {
        [[NetworkCenter getInstance] signUp:username password:password];
    }
    
    //[self performSegueWithIdentifier:@"toSearchView" sender:self];
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
