//
//  BLEPeripheral.m
//  BLEScanner
//
//  Created by Jason George on 12/23/15.
//  Copyright © 2015 Jason George. All rights reserved.
//

#import "BLEPeripheral.h"

static NSString * const kDefaultName = @"<Unknown Device>";
static NSString * const kDefaultUuid = @"";

@implementation BLEPeripheral
{
    CBPeripheral *_cbPeripheral;
}

#pragma mark - Lifecycle Management

- (instancetype)initWithCBPeripheral:(CBPeripheral *)peripheral
{
    self = [super init];
    if (self) {
        _cbPeripheral = peripheral;
    }
    return self;
}

#pragma mark - Properties

- (NSString *)name
{
    NSString *name = [_cbPeripheral name];
    if (name == nil || [name length] == 0) {
        name = kDefaultName;
    }
    return name;
}

- (NSString *)uuid
{
    NSString *uuid = [[_cbPeripheral identifier] UUIDString];
    if (uuid == nil || [uuid length] == 0) {
        uuid = kDefaultUuid;
    }
    return uuid;
}

#pragma mark - Operations
- (BOOL)isEqualToCBPeripheral:(CBPeripheral *)peripheral
{
    return [_cbPeripheral isEqual:peripheral];
}

#pragma mark - CBPeripheralDelegate Protocol

- (void) peripheral:(CBPeripheral *)peripheral
didDiscoverServices:(NSError *)error
{
    NSMutableArray *servicesBuffer = [NSMutableArray arrayWithCapacity:[[peripheral services] count]];
    for (CBService *service in [peripheral services]) {
        NSLog(@"Discovered service for %@: %@",
              [self name],
              [service UUID]);
        [servicesBuffer addObject:[[service UUID] description]];
    }
    _services = [servicesBuffer copy];
}

@end
