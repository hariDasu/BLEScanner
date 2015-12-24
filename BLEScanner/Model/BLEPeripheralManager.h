//
//  BLEPeripheralManager.h
//  BLEScanner
//
//  Created by Jason George on 12/23/15.
//  Copyright © 2015 Jason George. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef NS_ENUM(NSUInteger, BLEPeripheralManagerState) {
    BLEPeripheralManagerStateOffline = 0,
    BLEPeripheralManagerStateAvailable = 1,
    BLEPeripheralManagerStateScanning = 2
};

@interface BLEPeripheralManager : NSObject <CBCentralManagerDelegate>

@property (nonatomic, strong, readonly) NSArray *peripherals;
@property (nonatomic, assign, readonly) BLEPeripheralManagerState state;

#pragma mark - Lifecycle Management
+ (instancetype)sharedInstance;

#pragma mark - Operations
- (void)scanForPeripherals;
- (void)stopScan;

@end
