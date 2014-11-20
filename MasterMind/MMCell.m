//
//  MMCell.m
//  MasterMind
//
//  Created by Guillem Fernández González on 20/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import "MMCell.h"

@interface MMCell()

@property (nonatomic, strong) UIBezierPath *bezierPath;

@end

@implementation MMCell

- (id)init {
    
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor clearColor];
        self.bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 0, 0)];
        [self setIsAccessibilityElement: YES];
    }
    
    return self;
}

// Update bezier based on view size
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    if (_color != color) {
        _color = color;
        self.accessibilityLabel = [color description];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [self.color setFill];
    
    [self.bezierPath removeAllPoints];
    [self.bezierPath appendPath:[UIBezierPath bezierPathWithOvalInRect:self.bounds]];
    [self.bezierPath fill];
}


@end
