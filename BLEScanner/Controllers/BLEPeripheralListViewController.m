//
//  ViewController.m
//  BLEScanner
//
//  Created by Jason George on 12/23/15.
//  Copyright © 2015 Jason George. All rights reserved.
//

#import "BLEPeripheralListViewController.h"
#import "BLEPeripheralManager.h"
#import "BLEPeripheral.h"
#import "BLEActivityIndicatorView.h"
#import "BLEPeripheralDetailViewController.h"

static NSString * const kPeripheralTableViewCellIdentifier = @"PeripheralTableViewCell";
static NSString * const kPeripheralDetailViewSegueIdentifier = @"PeripheralDetailSegue";
static const NSTimeInterval kDefaultScanTime = 3.0;

@interface BLEPeripheralListViewController ()

@end

@implementation BLEPeripheralListViewController
{
    BLEActivityIndicatorView *_activityIndicatorView;
    BLEPeripheralManager *_peripheralManager;
    NSTimer *_scanTimer;
}

#pragma mark - Lifecycle Management

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _activityIndicatorView = [[BLEActivityIndicatorView alloc] initWithFrame:self.view.frame];
    _peripheralManager = [BLEPeripheralManager sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selectedIndexPath = [_peripheralTableView indexPathForSelectedRow];
    [_peripheralTableView deselectRowAtIndexPath:selectedIndexPath
                                        animated:NO];
    [super viewWillAppear:animated];
    
}

#pragma mark - Operations

- (IBAction)scanButton_onTouchUpInside:(id)sender
{
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView startAnimating];
    [self.view setUserInteractionEnabled:NO];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [_peripheralManager scanForPeripherals];
    _scanTimer = [NSTimer scheduledTimerWithTimeInterval:kDefaultScanTime
                                                  target:self
                                                selector:@selector(stopScanWithTimer:)
                                                userInfo:nil
                                                 repeats:NO];
}

#pragma mark - BLE Scan Timer

- (void)stopScanWithTimer:(NSTimer *)timer
{
    NSAssert(_scanTimer == timer, @"Unknown timer");
    if (_scanTimer == timer) {
        NSLog(@"Stopping peripheral scan");
        
        [_scanTimer invalidate];
        _scanTimer = nil;
        
        [_peripheralManager stopScan];
        [_peripheralTableView reloadData];
        
        [_activityIndicatorView removeFromSuperview];
        [_activityIndicatorView stopAnimating];
        [self.view setUserInteractionEnabled:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        NSLog(@"Found %i peripheral(s)", [[_peripheralManager peripherals] count]);
    }
}

#pragma mark - UITableViewDelegate Protocol

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSAssert(_peripheralTableView == tableView, @"Unknown table view");
    if (_peripheralTableView == tableView) {
        
    }
}

#pragma mark - UITableViewDataSource Protocol

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 0;
    
    NSAssert(_peripheralTableView == tableView, @"Unknown table view");
    if (_peripheralTableView == tableView) {
        sections = 1;
    }
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    NSAssert(_peripheralTableView == tableView, @"Unknown table view");
    if (_peripheralTableView == tableView) {
        rows = [[_peripheralManager peripherals] count];
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPeripheralTableViewCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kPeripheralTableViewCellIdentifier];
    }
    
    NSAssert(_peripheralTableView == tableView, @"Unknown table view");
    if (_peripheralTableView == tableView) {
        
        if ([[_peripheralManager peripherals] count] > indexPath.row) {
            
            id object = [[_peripheralManager peripherals] objectAtIndex:indexPath.row];
            if ([object isKindOfClass:[BLEPeripheral class]]) {
                BLEPeripheral *peripheral = (BLEPeripheral *)object;
                cell.textLabel.text = [peripheral name];
                cell.detailTextLabel.text = [peripheral uuid];
            }
        }
        
        
    }
    
    return cell;
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
    if ([segue.identifier isEqualToString:kPeripheralDetailViewSegueIdentifier]) {
        
        NSIndexPath *indexPath = [_peripheralTableView indexPathForSelectedRow];
        if (indexPath.row < [[_peripheralManager peripherals] count]) {
            
            id object = [[_peripheralManager peripherals] objectAtIndex:indexPath.row];
            if ([object isKindOfClass:[BLEPeripheral class]]) {
                BLEPeripheral *peripheral = (BLEPeripheral *)object;
                
                if ([segue.destinationViewController isKindOfClass:[BLEPeripheralDetailViewController class]]) {
                    BLEPeripheralDetailViewController *detailViewController = (BLEPeripheralDetailViewController *)segue.destinationViewController;
                    detailViewController.peripheral = peripheral;
                }
            }
            
        }
    }
}

@end
