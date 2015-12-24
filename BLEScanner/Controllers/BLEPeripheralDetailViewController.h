//
//  BLEPeripheralDetailViewController.h
//  BLEScanner
//
//  Created by Jason George on 12/23/15.
//  Copyright © 2015 Jason George. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEPeripheral.h"

@interface BLEPeripheralDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) BLEPeripheral *peripheral;
@property (nonatomic, strong) IBOutlet UITableView *serviceTableView;

@end
