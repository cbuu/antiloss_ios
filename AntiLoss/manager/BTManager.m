//
//  BTManager.m
//  AntiLoss
//
//  Created by cbuu on 15/11/24.
//  Copyright © 2015年 cbuu. All rights reserved.
//

#import "BTManager.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface BTManager()<CBCentralManagerDelegate,CBPeripheralDelegate>
{
    CBCentralManager * manager;
    
    NSMutableDictionary   * devicesDic;
    NSMutableDictionary * characteristicInfos;
    
    BOOL state;
}

@end

@implementation BTManager

+ (instancetype)getInstance
{
    static BTManager * instance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[BTManager alloc] init];
        
    });
    
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        devicesDic = [NSMutableDictionary dictionary];
        characteristicInfos = [NSMutableDictionary dictionary];
        self.isConnect = NO;
    }
    return self;
}

- (BOOL)isAntiloss:(NSDictionary*)dic
{
    NSArray* array = dic[@"kCBAdvDataServiceUUIDs"];
    if (array) {
        CBUUID * uuid = array[0];
        
        if (uuid && [uuid.UUIDString isEqualToString:@"FEE7"]){
            return YES;
        }
    }
    return NO;
}

- (NSString*)parseMacFromAdvData:(NSDictionary*)dic
{
    id manufacturerData = dic[@"kCBAdvDataManufacturerData"];
    NSData * data = [NSData dataWithBytes:[manufacturerData bytes]+2 length:6];
    NSString * mac = [self hexDataToString:data];
    return mac;
}

- (NSString *)hexDataToString:(NSData *)data
{
    const unsigned char *dataBuf = (const unsigned char *)[data bytes];
    NSUInteger length = [data length];
    NSMutableString *hex = [NSMutableString stringWithCapacity:(length*2)];
    for(int i=0; i<length; i++)
        [hex appendString:[NSString stringWithFormat:@"%02X", dataBuf[i]]];
    
    return [NSString stringWithString:hex];
}





#pragma mark -public method

- (void)setUp
{
    manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)scan
{
    if (state) {
        [manager scanForPeripheralsWithServices:nil options:nil];
    }
}

- (void)stopScan
{
    [manager stopScan];
}

- (BOOL)getBTState
{
    if (manager) {
       if(manager.state == CBCentralManagerStatePoweredOn)
           return YES;
    }
    return false;
}

- (void)connect:(AntiLossDevice*)device{
    if (device) {
        CBPeripheral * peripheral = devicesDic[device.deviceMac];
        if (peripheral) {
            [manager connectPeripheral:peripheral options:nil];
        }
    }
}

- (void)disconnectAllDevices{
    if (manager.isScanning) {
        [manager stopScan];
    }
    [characteristicInfos removeAllObjects];
    
    [devicesDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        CBPeripheral * p = obj;
        if (p.state == CBPeripheralStateConnected) {
            [manager cancelPeripheralConnection:obj];
        }
    }];
}

- (void)makeSound:(AntiLossDevice*)device{
    if (device) {
        CBPeripheral * peripheral = devicesDic[device.deviceMac];
        if (peripheral) {
            char b[1];
            b[0] = 1&0xFF;
            NSData* data = [NSData dataWithBytes:b length:1];
            [peripheral writeValue:data forCharacteristic:characteristicInfos[peripheral] type:CBCharacteristicWriteWithResponse];
        }
    }
}

#pragma mark - centralManager delegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    if ([self isAntiloss:advertisementData]){
            if (self.managerDelegate) {
                
                //TODO  del
                if (![peripheral.name isEqualToString:@"aqtracker"]) {
                    return;
                }
                //
                
                NSString * mac = [self parseMacFromAdvData:advertisementData];
                
                CBPeripheral * p = devicesDic[mac];
                if (nil == p) {
                    devicesDic[mac] = peripheral;
                }
                AntiLossDevice * device = [[AntiLossDevice alloc] init];
                device.deviceName = peripheral.name;
                device.deviceMac  = mac;
                
                [self.managerDelegate deviceFound:device];
            }
        }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral connected");
    self.isConnect = YES;
    peripheral.delegate = self;
    if (self.managerDelegate) {
        [self.managerDelegate deviceConnectResult:TRUE];
        [peripheral discoverServices:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.isConnect = NO;
    if (error) {
        return;
    }
    if (self.managerDelegate) {
        [self.managerDelegate deviceDisconnectResult:YES];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@ connected fail",peripheral.name);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central) {
        state = (central.state == CBCentralManagerStatePoweredOn);
    }
}


#pragma mark - peripheral delegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service %@", service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FE21"]]) {
            characteristicInfos[peripheral] = characteristic;
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    //NSData *data = characteristic.value;
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    
}
@end
