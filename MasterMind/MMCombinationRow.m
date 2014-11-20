//
//  MMCombinationRow.m
//  MasterMind
//
//  Created by Guillem Fernández González on 11/11/14.
//  Copyright (c) 2014 Guillem Fern√°ndez Gonz√°lez. All rights reserved.
//

#import "MMCombinationRow.h"
#import "MMResultCell.h"
#import "MMCell.h"

@implementation MMCombinationRow

- (id)init
{
    self = [super init];
    
    if (self) {
        
        MMResultCell *result = [[MMResultCell alloc] init];
        result.translatesAutoresizingMaskIntoConstraints = NO;
        result.contentMode = UIViewContentModeRedraw;
        result.accessibilityLabel = @"Result";

        [self addSubview:result];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"view": result}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"view": result}]];

        UIView *first = result;
        MMCell *cell;
        for (int n=0; n<4; n++) {
            cell = [[MMCell alloc] init];

            cell.translatesAutoresizingMaskIntoConstraints = NO;
            cell.contentMode = UIViewContentModeRedraw;
            cell.accessibilityLabel = [NSString stringWithFormat:@"Cell %d:", n];
            cell.userInteractionEnabled = YES;
            
            [self addSubview:cell];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previous][view(==previous)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"previous": first, @"view": cell}]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"view": cell}]];
            
            UITapGestureRecognizer *colorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeColor:)];
            [cell addGestureRecognizer:colorTap];

        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"view": cell}]];
        self.accessibilityLabel = @"Combination Row:'    '";
    }
    
    return self;
}

#pragma mark - Tap responder methods

- (void)changeColor:(UITapGestureRecognizer *)gesture
{
    // If we tapped on a color cell
    if ([gesture.view isKindOfClass:[MMCell class]]) {
        MMCell *cell = (MMCell *)gesture.view;
        NSString *newColor;
        
        if ([cell.color isEqual:[UIColor clearColor]]) {
            cell.color = [UIColor redColor];
            newColor = @"red";
        } else if ([cell.color isEqual:[UIColor redColor]]) {
            cell.color = [UIColor yellowColor];
            newColor = @"yellow";
        } else if ([cell.color isEqual:[UIColor yellowColor]]) {
            cell.color = [UIColor greenColor];
            newColor = @"green";
        } else if ([cell.color isEqual:[UIColor greenColor]]) {
            cell.color = [UIColor blueColor];
            newColor = @"blue";
        } else if ([cell.color isEqual:[UIColor blueColor]]) {
            cell.color = [UIColor clearColor];
            newColor = @"";
        }
        NSMutableString *currentLabel = [cell.accessibilityLabel mutableCopy];
        NSRange rightPart = [cell.accessibilityLabel rangeOfString:@":"];
        cell.accessibilityLabel =[NSString stringWithFormat:@"%@%@", [currentLabel substringToIndex:rightPart.location + 1], newColor ];
    }
}

@end
