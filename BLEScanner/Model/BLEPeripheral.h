//
//  BLEPeripheral.h
//  BLEScanner
//
//  Created by Jason George on 12/23/15.
//  Copyright © 2015 Jason George. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEPeripheral : NSObject <CBPeripheralDelegate>

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *uuid;
@property (nonatomic, strong, readonly) NSArray *services;

#pragma mark - Lifecycle Management
// designated initializer
- (instancetype)initWithCBPeripheral:(CBPeripheral *)peripheral;

#pragma mark - Operations
- (BOOL)isEqualToCBPeripheral:(CBPeripheral *)peripheral;

@end
