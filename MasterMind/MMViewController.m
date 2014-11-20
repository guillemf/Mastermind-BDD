//
//  MMViewController.m
//  MasterMind
//
//  Created by Guillem Fernández González on 30/09/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import "MMViewController.h"
#import "MMCombinationRow.h"

#define max_attemps 9

@interface MMViewController ()

@end

@implementation MMViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]"
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

    }
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view]|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:@{@"view": lastView}]];

}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Did appear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
