//
//  MMCell.m
//  MasterMind
//
//  Created by Guillem Fernández González on 20/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import "MMCell.h"

@implementation MMCell

- (id)init {
    
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor clearColor];
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
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {

    float offset = 5.0;
    
    NSValue *shapeSize = [NSValue valueWithCGSize:CGSizeMake(self.bounds.size.width - offset*2, self.bounds.size.height - offset*2)];
    [self drawShapeWithSize:shapeSize offset:[NSNumber numberWithFloat:offset]];
}


- (void)drawShapeWithSize:(NSValue *)vsize offset:(NSNumber *)voffset
{
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGSize  size    = [vsize CGSizeValue];
    float   offset  = [voffset floatValue];
    
    //// Color Declarations
    UIColor* fill = [self.color copy];
    CGFloat fillHSBA[4];
    [fill getHue: &fillHSBA[0] saturation: &fillHSBA[1] brightness: &fillHSBA[2] alpha: &fillHSBA[3]];
    
    UIColor* stroke = [UIColor colorWithHue: fillHSBA[0] saturation: fillHSBA[1] brightness: 0.7 alpha: fillHSBA[3]];
    
    //// Oval Drawing
    CGContextSaveGState(context);
    
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(offset, offset, size.width, size.height)];
    [fill setFill];
    [ovalPath fill];
    [stroke setStroke];
    ovalPath.lineWidth = 3;
    [ovalPath stroke];
    
    CGContextRestoreGState(context);
}

@end
