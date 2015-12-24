//
//  AntilossTableViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/12/3.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "AntilossTableViewController.h"
#import "UserManager.h"
#import "network/NetworkCenter.h"
#import "AntiLossDevice.h"
#import "AntilossSearchViewController.h"
#import "AntilossViewController.h"
#import "MessageTableViewController.h"
#import <UIImageView+AFNetworking.h>

@interface AntilossTableViewController ()<GetDevicesInfoDelegate,SearchDelegate,UnBoundDeviceDelegate>
{
    NSMutableArray * devices;//(antilossDevice)
    
    AntiLossDevice * seletedDevice;
}

@end

@implementation AntilossTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    devices = [NSMutableArray array];
    
    NSArray * devicesMac = [[UserManager getInstance] getDevices];
    
    [NetworkCenter getInstance].getDevicesInfoDelegate = self;
    [NetworkCenter getInstance].unBoundDeviceDelegate = self;
    
    
    if (devicesMac.count > 0) {
        [[NetworkCenter getInstance] batchGetDevicesInfo:devicesMac];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)addButtonClick:(id)sender {
    NSLog(@"begin to search Device");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return devices.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"deviceInfoCell" forIndexPath:indexPath];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"deviceInfoCell"];
    }
    
    AntiLossDevice * device = devices[indexPath.row];
    
    cell.textLabel.text = device.deviceName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    seletedDevice = devices[indexPath.row];
    
    [self performSegueWithIdentifier:@"toMyDeviceView" sender:self];
    NSLog(@"select %@",seletedDevice.deviceName);
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        seletedDevice = devices[indexPath.row];
        [[NetworkCenter getInstance] unBoundDeviceWithMac:seletedDevice.deviceMac];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"解绑";
}

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


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toSearchViewController"]) {
        AntilossSearchViewController * vc = segue.destinationViewController;
        
        vc.searchDelegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"toMyDeviceView"]) {
        AntilossViewController * vc = segue.destinationViewController;
        vc.device = seletedDevice;
        vc.title = seletedDevice.deviceName;
    }
}


- (void)getDevicesInfo:(NSArray *)infos{
    if (infos) {
        [infos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary * dic = obj;
            [devices addObject:[[AntiLossDevice alloc] initWithDic:dic]];
        }];
    }
    [self.tableView reloadData];
}

#pragma mark - searchDelegate

- (void)succeedToBoundDevice:(AntiLossDevice *)device{
    if (device) {
        [devices addObject:device];
        [self.tableView reloadData];
    }
}

- (void)unBoundDeviceResult:(BOOL)isSuccees{
    if (isSuccees) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"解绑成功" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UserManager getInstance].user unBoundDevice:seletedDevice.deviceMac];
            [devices removeObject:seletedDevice];
            [self.tableView reloadData];
        }];
        [alertController addAction:alertAction];
        
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - action
- (IBAction)messageButtonClick:(id)sender {
    MessageTableViewController * mtvc = [[MessageTableViewController alloc] init];
    
    [self.navigationController showViewController:mtvc sender:self];
}


@end
