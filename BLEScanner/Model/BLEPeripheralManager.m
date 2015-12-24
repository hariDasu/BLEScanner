//
//  BLEPeripheralManager.m
//  BLEScanner
//
//  Created by Jason George on 12/23/15.
//  Copyright © 2015 Jason George. All rights reserved.
//

#import "BLEPeripheralManager.h"
#import "BLEPeripheral.h"

@implementation BLEPeripheralManager
{
    CBCentralManager *_centralManager;
    NSMutableArray *_peripheralBuffer;
}

#pragma mark - Lifecycle Management

- (instancetype)init
{
    self = [super init];
    if (self) {
        _peripheralBuffer = [NSMutableArray new];
        _state = BLEPeripheralManagerStateOffline;
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self
                                                               queue:nil];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    NSAssert(self == [BLEPeripheralManager class], @"BLEPeripheralManager is not designed to be subclassed");
    
    static BLEPeripheralManager *sharedPeripheralManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPeripheralManager = [BLEPeripheralManager new];
    });
    
    return sharedPeripheralManager;
}

#pragma mark - Operations

- (void)scanForPeripherals
{
    if (_state == BLEPeripheralManagerStateAvailable) {
        _peripheralBuffer = [NSMutableArray new];
        _state = BLEPeripheralManagerStateScanning;
        [_centralManager scanForPeripheralsWithServices:nil
                                                options:nil];
    }
}

- (void)stopScan
{
    if (_state == BLEPeripheralManagerStateScanning) {
        [_centralManager stopScan];
        _state = BLEPeripheralManagerStateAvailable;
    }
}

#pragma mark - CBCentralManagerDelegate Protocol

- (void)centralManager:(CBCentralManager *)central
  didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral discoverServices:nil];
    NSLog(@"Connected to %@: %@",
          [peripheral name],
          [peripheral state] == CBPeripheralStateConnected ? @"YES" : @"NO");
}

- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    NSUInteger peripheralIndex = [_peripheralBuffer indexOfObjectPassingTest:^BOOL(id object, NSUInteger index, BOOL *stop) {
        if ([object isKindOfClass:[BLEPeripheral class]]) {
            
            BLEPeripheral *blePeripheral = (BLEPeripheral *)object;
            if ([blePeripheral isEqualToCBPeripheral:peripheral]) {
                NSLog(@"Duplicate: %@",[blePeripheral name]);
                *stop = YES;
                return YES;
            }
        }
        return NO;
    }];
   
    if (peripheralIndex == NSNotFound) {
        NSLog(@"Discovered: %@",[peripheral name]);
        BLEPeripheral *blePeripheral = [[BLEPeripheral alloc] initWithCBPeripheral:peripheral];
        [peripheral setDelegate:blePeripheral];
        [_peripheralBuffer addObject:blePeripheral];
        [_centralManager connectPeripheral:peripheral
                                   options:nil];
    }
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (_state == BLEPeripheralManagerStateScanning) {
        [_centralManager stopScan];
    }
    
    switch ([central state]) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            _state = BLEPeripheralManagerStateOffline;
            break;
            
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
            _state = BLEPeripheralManagerStateAvailable;
            break;
            
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            _state = BLEPeripheralManagerStateOffline;
            break;
            
        case CBCentralManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            _state = BLEPeripheralManagerStateOffline;
            break;
            
        case CBCentralManagerStateUnknown:
        default:
            NSLog(@"CoreBluetooth BLE state is unknown");
            _state = BLEPeripheralManagerStateOffline;
            break;
    }
}

#pragma mark - Property Overrides

- (NSArray *)peripherals
{
    return [_peripheralBuffer copy];
}


@end
