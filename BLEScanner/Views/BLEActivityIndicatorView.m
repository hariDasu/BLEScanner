//
//  BLEActivityIndicatorView.m
//  BLEScanner
//
//  Created by Jason George on 12/23/15.
//  Copyright © 2015 Jason George. All rights reserved.
//

#import "BLEActivityIndicatorView.h"

static const CGFloat kDefaultObstructionViewAlpha = 0.2;

@implementation BLEActivityIndicatorView {
    UIView *_obstructionView;
    UIActivityIndicatorView *_activityIndicatorView;
}

#pragma mark - Lifecycle Management

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    _obstructionView = [[UIView alloc] initWithFrame:self.frame];
    _obstructionView.backgroundColor = [UIColor blackColor];
    _obstructionView.alpha = kDefaultObstructionViewAlpha;
    [self addSubview:_obstructionView];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_activityIndicatorView];
}

#pragma mark - Operations

- (void)startAnimating
{
    [_activityIndicatorView startAnimating];
}

- (void)stopAnimating
{
    [_activityIndicatorView stopAnimating];
}

#pragma mark - Overrides

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    CGPoint activityIndicatorCenter = CGPointMake(frame.size.width / 2.0,
                                                  frame.size.height / 2.0);
    [_activityIndicatorView setCenter:activityIndicatorCenter];
    _obstructionView.frame = self.frame;
}

@end
