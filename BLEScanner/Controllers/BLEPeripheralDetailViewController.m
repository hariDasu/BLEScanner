//
//  BLEPeripheralDetailViewController.m
//  BLEScanner
//
//  Created by Jason George on 12/23/15.
//  Copyright © 2015 Jason George. All rights reserved.
//

#import "BLEPeripheralDetailViewController.h"

static NSString * const kServiceTableViewCellIdentifier = @"ServiceTableViewCell";
static NSString * const kSectionHeaderTitle = @"Services";

@interface BLEPeripheralDetailViewController ()

@end

@implementation BLEPeripheralDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [_peripheral name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate Protocol

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSAssert(_serviceTableView == tableView, @"Unknown table view");
    if (_serviceTableView == tableView) {
        
    }
}

#pragma mark - UITableViewDataSource Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 0;
    
    NSAssert(_serviceTableView == tableView, @"Unknown table view");
    if (_serviceTableView == tableView) {
        sections = 1;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    NSAssert(_serviceTableView == tableView, @"Unknown table view");
    if (_serviceTableView == tableView) {
        rows = [[_peripheral services] count];
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle = @"";
    if (section == 0) {
        headerTitle = kSectionHeaderTitle;
    }
    return headerTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kServiceTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kServiceTableViewCellIdentifier];
    }
    
    NSAssert(_serviceTableView == tableView, @"Unknown table view");
    if (_serviceTableView == tableView) {
        
        if ([[_peripheral services] count] > indexPath.row) {
            id object = [[_peripheral services] objectAtIndex:indexPath.row];
            if ([object isKindOfClass:[NSString class]]) {
                NSString *service = (NSString *)object;
                cell.textLabel.text = service;
            }
        }
    }
    
    return cell;
}

@end
