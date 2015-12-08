//
//  AntilossSearchViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/12/2.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "AntilossSearchViewController.h"
#import "DeviceTableViewCell.h"
#import "manager/BTManager.h"
#import "NetworkCenter.h"
#import "UserManager.h"

@interface AntilossSearchViewController ()<BTManagerDelegate,BoundDeviceDelegate>
{
    UINib * deviceNib;
    
    AntiLossDevice * deviceToBound;
    NSMutableArray * foundDevices;
}

@end

@implementation AntilossSearchViewController

- (instancetype)init{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    foundDevices = [NSMutableArray array];
    
    self.tableView.tableFooterView = [UIView new];
    
    [NetworkCenter getInstance].boundDeviceDelegate = self;
    [BTManager getInstance].managerDelegate = self;
    [[BTManager getInstance] scan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [BTManager getInstance].managerDelegate = nil;
    [[BTManager getInstance]stopScan];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return foundDevices.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    if (indexPath.row == foundDevices.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"deviceCell"];
        
        AntiLossDevice * device = foundDevices[indexPath.row];
        
        UILabel * label = (UILabel*)[cell viewWithTag:1];
        
        label.text = device.deviceName;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == foundDevices.count) {
//        deviceToBound = [[AntiLossDevice alloc] init];
//        deviceToBound.deviceMac = @"009";
//        deviceToBound.deviceName = @"timo";
//        [[NetworkCenter getInstance] boundDeviceWithMac:deviceToBound.deviceMac];
//        
//        [BTManager getInstance].searchDeviceDelegate = nil;
//        [[BTManager getInstance]stopScan];
        return;
    }

    
    deviceToBound = foundDevices[indexPath.row];
    [[NetworkCenter getInstance] boundDeviceWithMac:deviceToBound.deviceMac];
    
    [BTManager getInstance].managerDelegate = nil;
    [[BTManager getInstance]stopScan];
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

#pragma mark - delegate

- (void)deviceFound:(AntiLossDevice *)device{
    if (device&&![[UserManager getInstance] isBounded:device.deviceMac]) {
        
        [foundDevices addObject:device];
        
        [self.tableView reloadData];
    }
}

- (void)boundDeviceResult:(BOOL)isSuccees{
    if (isSuccees) {
        
        
        [self.navigationController popViewControllerAnimated:YES];
        if (self.searchDelegate) {
            [self.searchDelegate succeedToBoundDevice:deviceToBound];
        }
    }
    
}

@end
