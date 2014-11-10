//
//  MMResultCell.m
//  MasterMind
//
//  Created by Guillem Fernández González on 22/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import "MMResultCell.h"

@interface MMResultCell()

@property (nonatomic, strong) NSArray *bezierPaths;

@end

@implementation MMResultCell

- (id)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _result = @"";
        _color = [UIColor blackColor];
    }
    
    return self;
}

- (void)setResult:(NSString *)result
{
    if (_result != result) {
        
        BOOL changedSymbol = NO;
        int stringLenth = 0;
        
        unichar lastChar = result.length > 0?[result characterAtIndex:0]:' ';

        for (int n=0; n<result.length; n++) {
            if (lastChar != [result characterAtIndex:n]) {
                if (!changedSymbol) {
                    changedSymbol = YES;
                    lastChar = [result characterAtIndex:n];
                } else {
                    break;
                }
            }
            stringLenth++;
        }
        
        _result = [result substringWithRange:NSMakeRange(0, stringLenth)];
        
        [self generateBezierPaths];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self generateBezierPaths];
}

- (void)setColor:(UIColor *)color
{
    if (_color != color) {
        _color = color;
        [self generateBezierPaths];
    }
}

- (void)drawRect:(CGRect)rect {

    [self.color setStroke];
    [self.color setFill];

    unichar leftchar = [self.result characterAtIndex:0];
    NSString *combination = [self.result stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    int currentElement = 0;
    
    for (UIBezierPath *path in self.bezierPaths) {
        if ([combination characterAtIndex:currentElement] == leftchar) {
            [path fill];
        } else {
            [path stroke];
        }
        currentElement++;
    }
    
}

#pragma mark - Private methods

- (void)generateBezierPaths
{
    if (self.bounds.size.height<=0 || self.bounds.size.width<=0) {
        [self generateEmptyBeziers];
    } else {
        // Obtain first char
        NSString *combination = [self.result stringByReplacingOccurrencesOfString:@" " withString:@""];

        // Obtain rectangle ration
        float K = self.bounds.size.height/self.bounds.size.width;
        // Obtain number of items
        long N = combination.length;
        
        // Obtain grid sizes
        float verItems = ceil(sqrtf(K*N));
        float horItems = ceil(sqrtf(N/K));
        
        // Items horizontally
        float gridHeigh = self.bounds.size.height / verItems;
        float gridWidth = self.bounds.size.width / horItems;
        
        int currentElement;
        
        NSMutableArray *tmpBeziers = [NSMutableArray arrayWithCapacity:N];
        UIBezierPath *tmpPath;

        for (int y = 0; y<verItems; y++) {
            for (int x = 0; x<horItems; x++) {
                currentElement = (horItems*y)+x;
                if (currentElement >= N) {
                    break;
                }
                tmpPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x*gridWidth, y*gridHeigh, gridWidth, gridHeigh)];
                tmpPath.lineWidth = 1;
                [tmpBeziers addObject:tmpPath];
            }
        }
        
        self.bezierPaths = [tmpBeziers copy];
    }
    
    [self setNeedsDisplay];
}

- (void)generateEmptyBeziers
{
    NSMutableArray *tmpBeziers = [[NSMutableArray alloc] initWithCapacity:_result.length];
    
    for (int n=0; n<_result.length; n++) {
        [tmpBeziers addObject:[[UIBezierPath alloc] init]];
    }
    
    self.bezierPaths = [tmpBeziers copy];

}
@end
