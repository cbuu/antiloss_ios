//
//  SettingViewController.m
//  AntiLoss
//
//  Created by iorideng on 16/3/14.
//  Copyright © 2016年 cbuu. All rights reserved.
//

#import "SettingViewController.h"
#import "manager/UserManager.h"
#import "IOIndicatorView.h"
#import "NetworkCenter.h"

@interface SettingViewController () <SaveUserInfoDelegate>
{
    NSArray * settingArray;
    NSMutableArray * textArray;
    IOIndicatorView * indicatorView;
    UIAlertController * alertController;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    settingArray = [NSArray arrayWithObjects:@"用户名：",@"手机号码：", nil];
    textArray    = [NSMutableArray array];
    [textArray addObject:[UserManager getInstance].user.username];
    [textArray addObject:[UserManager getInstance].user.teleNum];
    
    self.tableView.tableFooterView = [UIView new];

    
    [NetworkCenter getInstance].saveUserInfoDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return settingArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * reuseID = @"SettingTableReuseID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    
    NSString * detailText= textArray[indexPath.row];
    cell.textLabel.text = settingArray[indexPath.row];
    if (detailText!= nil) {
        cell.detailTextLabel.text = detailText;
    }else{
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (indexPath.row == 1) {
        alertController = [UIAlertController alertControllerWithTitle:@"请输入手机号码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * yes    = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString * teleNum = alertController.textFields[0].text;
            if (teleNum!=nil) {
                [UserManager getInstance].user.teleNum = teleNum;
                [textArray replaceObjectAtIndex:1 withObject:teleNum];
                [self.tableView reloadData];
            }
        }];
        
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypePhonePad;
        }];
        [alertController addAction:cancle];
        [alertController addAction:yes];
        
        [self presentViewController:alertController animated:yes completion:nil];
    }
    
    
}


- (IBAction)backButtonClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonClicked:(id)sender {
    [[NetworkCenter getInstance] saveUserInfo];
    
    indicatorView = [[IOIndicatorView alloc] init];
    [indicatorView show];
}

#pragma mark NetworkCenter delegate

- (void)saveUserInfoResult:(BOOL)isSuccess
{
    if (isSuccess) {
        [indicatorView hide];
        alertController = [UIAlertController alertControllerWithTitle:@"保存成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:alertAction];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }else{
        
    }
}

//#mark UITextFieldDelegate
//
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    NSCharacterSet *cs;
//    cs = [[NSCharacterSet characterSetWithCharactersInString:kAlphaNum] invertedSet];
//    NSString *filtered =
//    [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    BOOL basic = [string isEqualToString:filtered];
//    return basic;
//}

@end
