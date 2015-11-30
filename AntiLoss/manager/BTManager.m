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
    
    NSMutableArray * devicesPool;
    NSMutableSet   * devicesMacSet;
    
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
        devicesPool = [NSMutableArray array];
        devicesMacSet = [NSMutableSet set];
    }
    return self;
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

- (BOOL)getBTState
{
    if (manager) {
       if(manager.state == CBCentralManagerStatePoweredOn)
           return true;
    }
    return false;
}

#pragma mark - centralManager delegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    NSArray* array = advertisementData[@"kCBAdvDataServiceUUIDs"];
    if (array) {
        CBUUID * uuid = array[0];
        
        if (uuid && [uuid.UUIDString isEqualToString:@"FEE7"]) {
            if (self.searchDeviceDelegate) {
                NSString * mac = [self parseMacFromAdvData:advertisementData];
                [self.searchDeviceDelegate deviceFound:mac];
            }
        }
    }
    
    
    
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral connected");
    peripheral.delegate = self;
    
    [peripheral discoverServices:nil];
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
        NSLog(@"Discovered characteristic %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
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
