//
//  MMResultCell.m
//  MasterMind
//
//  Created by Guillem Fernández González on 22/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import "MMResultCell.h"

@interface MMResultCell()

@property (nonatomic, assign) unichar firstChar;

@end

@implementation MMResultCell

- (id)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.8f];
        _result = @"";
        _color = [UIColor blackColor];
        [self setIsAccessibilityElement: YES];
        self.accessibilityLabel = @"Result";
    }
    
    return self;
}

- (void)setResult:(NSString *)result
{
    if (_result != result) {
        
        BOOL changedSymbol = NO;
        int stringLenth = 0;
        
        unichar lastChar = result.length > 0?[result characterAtIndex:0]:' ';
        self.firstChar = lastChar;
        
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
        
        _result = [[result substringWithRange:NSMakeRange(0, stringLenth)] stringByReplacingOccurrencesOfString:@" " withString:@""];
        self.accessibilityLabel = [NSString stringWithFormat:@"Result %@", _result];
        
        [self setNeedsDisplay];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_result) {
        [self setNeedsDisplay];
    }
}

- (void)setColor:(UIColor *)color
{
    if (_color != color) {
        _color = color;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {

    [self drawResultWithBallOffset:CGPointMake(3, 3)];
}

#pragma mark - Private methods

- (void)drawBallAtContext:(CGContextRef)context withType:(NSNumber *)type atOffset:(NSValue *)voffset withSize:(NSValue *)vsize innerOffset:(NSValue *)vinnerOffset
{
    CGPoint offset      = [voffset CGPointValue];
    CGSize  size        = [vsize CGSizeValue];
    CGPoint innerOffset = [vinnerOffset CGPointValue];
    
    CGContextSaveGState(context);
    
    //// Outter Drawing
    CGContextTranslateCTM(context, offset.x , offset.y);
    
    UIBezierPath* outterPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(innerOffset.x, innerOffset.y, size.width, size.height)];
    if ([type isEqualToNumber:@0]) {
        [self.color setFill];
        [outterPath fill];
    } else {
        [self.color setStroke];
        outterPath.lineWidth = 1;
        [outterPath stroke];
    }
    
    CGContextRestoreGState(context);
    
    
    //// Inner Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, offset.x + innerOffset.x, offset.y + innerOffset.y);
    
    UIBezierPath* innerPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(innerOffset.x, innerOffset.y, (size.width - 2 * innerOffset.x), (size.height - 2 * innerOffset.y))];
    if ([type isEqualToNumber:@0]) {
        [UIColor.whiteColor setStroke];
        innerPath.lineWidth = 2;
        [innerPath stroke];
    } else {
        [self.color setStroke];
        innerPath.lineWidth = 2;
        [innerPath stroke];
    }
    
    CGContextRestoreGState(context);

}

- (void)drawResultWithBallOffset:(CGPoint)offset
{

    //// General Declarations

    //// Location calulations
    CGSize ballSize = CGSizeMake(self.bounds.size.width / 2 - (offset.x * 2), self.bounds.size.height / 2  - (offset.y * 2));
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Cell 1
    if (self.result.length >= 1)
    {
        NSNumber *fC = [self.result characterAtIndex:0] == self.firstChar ? @0:@1;
        
        [self drawBallAtContext:context
                       withType:fC
                       atOffset:[NSValue valueWithCGPoint:CGPointMake(0, 0)]
                       withSize:[NSValue valueWithCGSize:ballSize]
                    innerOffset:[NSValue valueWithCGPoint:offset]];

    }

    //// Cell 2
    if (self.result.length >= 2)
    {
         NSNumber *sC = [self.result characterAtIndex:1] == self.firstChar ? @0:@1;
    
        [self drawBallAtContext:context
                       withType:sC
                       atOffset:[NSValue valueWithCGPoint:CGPointMake(ballSize.width + (2 * offset.x), 0)]
                       withSize:[NSValue valueWithCGSize:ballSize]
                    innerOffset:[NSValue valueWithCGPoint:offset]];

    }
    
    
    //// Cell 3
    if (self.result.length >= 3)
    {
         NSNumber *tC = [self.result characterAtIndex:2] == self.firstChar ? @0:@1;
        
        [self drawBallAtContext:context
                       withType:tC
                       atOffset:[NSValue valueWithCGPoint:CGPointMake(0, ballSize.height + (2 * offset.y))]
                       withSize:[NSValue valueWithCGSize:ballSize]
                    innerOffset:[NSValue valueWithCGPoint:offset]];
    }

    //// Cell 4
    if (self.result.length >= 4)
    {
         NSNumber *fC = [self.result characterAtIndex:3] == self.firstChar ? @0:@1;
        
        [self drawBallAtContext:context
                       withType:fC
                       atOffset:[NSValue valueWithCGPoint:CGPointMake(ballSize.width + (2 * offset.x), ballSize.height + (2 * offset.y))]
                       withSize:[NSValue valueWithCGSize:ballSize]
                    innerOffset:[NSValue valueWithCGPoint:offset]];
    }

}

@end
