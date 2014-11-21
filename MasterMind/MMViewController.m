//
//  MMViewController.m
//  MasterMind
//
//  Created by Guillem Fernández González on 30/09/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import "MMViewController.h"
#import "MMCombinationRow.h"
#import "MMModel.h"

#define max_attemps 9

@interface MMViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) MMModel *model;

@end

@implementation MMViewController

- (id)init
{
    if (self = [super init]) {
        self.model = [[MMModel alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *lastView = nil;
    //Add max_attemps rows to the view
    for (int n=0; n<max_attemps; n++) {
        MMCombinationRow *rowView = [[MMCombinationRow alloc] init];
        rowView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:rowView];
        
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"view": rowView}]];
        if (lastView == nil) {
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];

            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[view]", statusBarFrame.size.height]
                                                                              options:0
                                                                              metrics:nil
                                                                                views:@{@"view": rowView}]];

        } else {
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[last_view][view(==last_view)]"
                                                                              options:0
                                                                              metrics:nil
                                                                                views:@{@"last_view": lastView, @"view": rowView}]];
        }
        
        lastView = rowView;
        rowView.accessibilityLabel = [NSString stringWithFormat:@"Combination Row %d:'    '", n];
        rowView.delegate = self;

    }
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"view": lastView}]];
    [self newGame];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - Delegate Methods

- (void)checkCombinationFor:(MMCombinationRow *)row
{
    if ([self isRowActive:row])
    {
        NSString *result = [self.model addAttempt:row.combination];
        if (result.length > 0) {
            if ([result characterAtIndex:0] != 'A') {
                result = [NSString stringWithFormat:@" %@", result];
            }
        }
                
        [row setResult:result];
        
        if ([result isEqualToString:@"AAAA"]) {
            // Winner
            UIAlertView *winnerAlert = [[UIAlertView alloc] initWithTitle:@"Winner!!!!"
                                                                  message:@"You broke the code"
                                                                 delegate:self
                                                        cancelButtonTitle:@"New Game"
                                                        otherButtonTitles:nil];
            winnerAlert.isAccessibilityElement = YES;
            [winnerAlert show];
        } else if (self.model.history.count >= max_attemps) {
            // Looser
            UIAlertView *winnerAlert = [[UIAlertView alloc] initWithTitle:@"Game finished!!!!"
                                                                  message:@"The code was too hard to break"
                                                                 delegate:self
                                                        cancelButtonTitle:@"New Game"
                                                        otherButtonTitles:nil];
            winnerAlert.isAccessibilityElement = YES;
            [winnerAlert show];
        }
    }
}

- (BOOL)isRowActive:(MMCombinationRow *)row
{
    NSUInteger rowIndex = [self.view.subviews indexOfObject:row];
    return rowIndex == self.model.history.count;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self newGame];
}

#pragma mark - Private Methods

- (void)newGame
{
    [self.model start];
    
    for (MMCombinationRow *row in self.view.subviews) {
        if ([row isKindOfClass:[MMCombinationRow class]]) {
            [row setCombination:@"0000"];
            [row setResult:@""];
        }
    }
    [self.view setNeedsDisplay];
}

#pragma mark - Public methods

- (NSString *)currentCombination
{
    return self.model.combination;
}

@end
