//
//  BLEActivityIndicatorView.h
//  BLEScanner
//
//  Created by Jason George on 12/23/15.
//  Copyright © 2015 Jason George. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLEActivityIndicatorView : UIView

#pragma mark - Operations
- (void)startAnimating;
- (void)stopAnimating;

@end
