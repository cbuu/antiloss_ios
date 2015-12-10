//
//  AntilLossListViewController.m
//  AntiLoss
//
//  Created by cbuu on 15/11/30.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "AntilLossListViewController.h"
#import "UIView+EasyGet.h"
#import "AntiLossDevice.h"
#import "BTManager.h"

#define kMyDeviceCellHeight 70

@interface AntilLossListViewController ()<BTManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView * m_tableView;
    
    NSMutableArray * m_devices;
}

@end

@implementation AntilLossListViewController

- (instancetype)init
{
    if (self = [super init]) {
        m_devices = [NSMutableArray array];
        
        [BTManager getInstance].managerDelegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"我的设备"];
    
    [self initView];
    
    [[BTManager getInstance] scan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [BTManager getInstance].managerDelegate = nil;
}

- (void)initView
{
    m_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    [self.view addSubview:m_tableView];

    m_tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)setUpLoadingCell:(UITableViewCell *)cell
{
    UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    indicatorView.frame = CGRectMake(10,(kMyDeviceCellHeight - indicatorView.height) / 2, indicatorView.width, indicatorView.height);
    [indicatorView startAnimating];
    [cell.contentView addSubview:indicatorView];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel* textLabel = [[UILabel alloc]init];
    
    textLabel.text= @"搜索中";
    [textLabel sizeToFit];
    
    textLabel.frame = CGRectMake(20 + indicatorView.width, 0, textLabel.width, kMyDeviceCellHeight);
    
    [cell.contentView addSubview:textLabel];
}



#pragma mark -tableview datasource



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_devices.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == m_devices.count) {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search_indicate"];
        
        [self setUpLoadingCell:cell];
        
        return cell;
    }
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"search_device"];
    
    
    AntiLossDevice * device = m_devices[indexPath.row];
    
    cell.textLabel.text = device.deviceName;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kMyDeviceCellHeight;
}

#pragma mark -tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == m_devices.count) {
        [m_tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    AntiLossDevice * device = m_devices[indexPath.row];
    
    NSLog(@"%@ selected",device.deviceName);
}

#pragma mark -searchDelegate

- (void)deviceFound:(NSString *)mac
{
    if (mac) {
        [m_devices addObject:[AntiLossDevice initWithMac:@"hehe" name:mac]];
        [m_tableView reloadData];
    }
}



@end
