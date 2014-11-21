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

@interface MMCombinationRow()

@property (nonatomic, strong) CALayer *bottomBorder;
@property (nonatomic, strong) MMResultCell *resultCell;
@property (nonatomic, strong) NSArray *colorCells;

@end

@implementation MMCombinationRow

- (id)init
{
    self = [super init];
    
    if (self) {
        
        self.resultCell = [[MMResultCell alloc] init];
        self.resultCell.translatesAutoresizingMaskIntoConstraints = NO;
        self.resultCell.contentMode = UIViewContentModeRedraw;
        self.resultCell.accessibilityLabel = @"Result";

        [self addSubview:self.resultCell];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"view": self.resultCell}]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"view": self.resultCell}]];

        NSMutableArray *colorCells = [NSMutableArray arrayWithCapacity:4];
        UIView *first = self.resultCell;
        UIView *previous = first;
        MMCell *cell;
        for (int n=0; n<4; n++) {
            cell = [[MMCell alloc] init];

            cell.translatesAutoresizingMaskIntoConstraints = NO;
            cell.contentMode = UIViewContentModeRedraw;
            cell.isAccessibilityElement = YES;
            cell.accessibilityLabel = [NSString stringWithFormat:@"Cell %d:", n];
            
            cell.userInteractionEnabled = YES;
            
            [self addSubview:cell];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previous][view(==first)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"first": first, @"previous": previous, @"view": cell}]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:@{@"view": cell}]];
            
            previous = cell;
            UITapGestureRecognizer *colorTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(changeColor:)];
            [cell addGestureRecognizer:colorTap];
            [colorCells addObject:cell];

        }
        
        self.colorCells = [colorCells copy];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[view]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:@{@"view": cell}]];
        // Add swipe gesture
        UISwipeGestureRecognizer *rowSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(checkCombination:)];
        rowSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:rowSwipe];
        
        self.accessibilityLabel = @"Combination Row:'    '";
        
        // Setup general look and feel
        self.backgroundColor = [UIColor whiteColor];
        
        self.bottomBorder = [CALayer layer];
        self.bottomBorder.borderColor = [UIColor grayColor].CGColor;
        self.bottomBorder.borderWidth = 0.5;

//        self.leftBorder = [CALayer layer];
//        self.leftBorder.borderColor = [UIColor grayColor].CGColor;
//        self.leftBorder.borderWidth = 1;

        [self.layer insertSublayer:self.bottomBorder atIndex:0];
//        [self.layer insertSublayer:self.leftBorder atIndex:1];

    }
    
    return self;
}

#pragma mark - private and event responder methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bottomBorder.frame = self.bounds;//CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1);
//    self.leftBorder.frame = CGRectMake(round(self.bounds.size.width/5), 0, 1, self.bounds.size.height);
}

- (void)callVerify
{
    if (self.delegate) {
        [self.delegate checkCombinationFor:self];
    }
}

- (UIColor *)encodeCellAtPossition:(NSUInteger)possition withValue:(int)value
{
    MMCell *cell = (MMCell *)[self.colorCells objectAtIndex:possition];
    NSString *newColor = @"";

    switch (value) {
        case 0:
            cell.color = [UIColor clearColor];
            newColor = @"";
            break;
        case 1:
            cell.color = [UIColor redColor];
            newColor = @"red";
            break;
        case 2:
            cell.color = [UIColor yellowColor];
            newColor = @"yellow";
            break;
        case 3:
            cell.color = [UIColor greenColor];
            newColor = @"green";
            break;
        case 4:
            cell.color = [UIColor blueColor];
            newColor = @"blue";
            break;
        default:
            cell.color = [UIColor clearColor];
            newColor = @"";
            break;
    }

    NSMutableString *currentLabel = [cell.accessibilityLabel mutableCopy];
    NSRange rightPart = [cell.accessibilityLabel rangeOfString:@":"];
    cell.accessibilityLabel =[NSString stringWithFormat:@"%@%@", [currentLabel substringToIndex:rightPart.location + 1], newColor ];
    
    return  cell.color;
}

- (int)decodeColorForCellAtPossition:(NSUInteger)possition
{
    MMCell *cell = (MMCell *)[self.colorCells objectAtIndex:possition];
    
    if ([cell.color isEqual:[UIColor clearColor]]) {
        return 0;
    } else if ([cell.color isEqual:[UIColor redColor]]) {
        return 1;
    } else if ([cell.color isEqual:[UIColor yellowColor]]) {
        return 2;
    } else if ([cell.color isEqual:[UIColor greenColor]]) {
        return 3;
    } else if ([cell.color isEqual:[UIColor blueColor]]) {
        return 4;
    } else {
        return 0;
    }

}

#pragma mark - Tap responder methods

- (void)checkCombination:(UISwipeGestureRecognizer *)gesture
{
    if (gesture.view == self && [self isComplete]) {
        
        [self callVerify];
        
    }
}

- (void)changeColor:(UITapGestureRecognizer *)gesture
{
    // Don't allow interaction with rows that are not the active one
    if (![self.delegate isRowActive:self]) return;
    
    // If we tapped on a color cell
    if ([gesture.view isKindOfClass:[MMCell class]]) {
        MMCell *cell = (MMCell *)gesture.view;
        NSUInteger possition = [self.colorCells indexOfObject:cell];
        int currentVal = [self decodeColorForCellAtPossition:possition];
        [self encodeCellAtPossition:possition withValue:currentVal+1];
    }
}

#pragma mark - Public methods

- (void)setResult:(NSString *)result
{
    [self.resultCell setResult:result];
}

- (NSString *)combination
{
    return [NSString stringWithFormat:@"%d%d%d%d",
            [self decodeColorForCellAtPossition:0],
            [self decodeColorForCellAtPossition:1],
            [self decodeColorForCellAtPossition:2],
            [self decodeColorForCellAtPossition:3]];
}

- (void)setCombination:(NSString *)combination
{
    int combinationValue = [combination intValue];
    
    for (int n=0; n<4; n++) {
        int val = combinationValue / pow(10, (3-n));
        [self encodeCellAtPossition:n withValue:val];
    }
}

- (BOOL)isComplete
{
    for (MMCell *subview in self.subviews) {
        if ([subview isKindOfClass:[MMCell class]]) {
            if ([subview.color isEqual:[UIColor clearColor]]) {
                return NO;
            }
        }
    }
    
    return YES;
}
@end
