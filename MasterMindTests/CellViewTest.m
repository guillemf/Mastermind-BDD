//
//  CellViewTest.m
//  MasterMind
//
//  Created by Guillem Fernández González on 20/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MMCell.h"

@interface CellViewTest : XCTestCase

@end

@implementation CellViewTest
{
    MMCell *cell;
}

- (void)setUp {
    [super setUp];
    cell = [[MMCell alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCellOnInitBackgroundIsTransparent {
    
    XCTAssertEqual(cell.backgroundColor, [UIColor clearColor]);
}

- (void)testWhenSizeChangesPathSizeChanges
{
    int width = arc4random_uniform(200);
    int height = arc4random_uniform(200);
    cell.frame = CGRectMake(0, 0, width, height);
    UIBezierPath *expectedBezier = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, width, height)];

    XCTAssertTrue(CGPathEqualToPath([expectedBezier CGPath], [cell.bezierPath CGPath]),
                  @"Bezier Path does not match expeted shape");
}

- (void)testCellOnInitColorIsTransparent {
    
    XCTAssertEqual(cell.color, [UIColor clearColor]);
}

- (void)testAccessibilityShouldBeEnabled {
    
    XCTAssertTrue([cell isAccessibilityElement], @"View accessibility should be enabled");
}

- (void)testWhenCellChangesColorAccessibilityLabelChangesText {
    
    float r = arc4random_uniform(255)/255.0f;
    float g = arc4random_uniform(255)/255.0f;
    float b = arc4random_uniform(255)/255.0f;
    float alpha = arc4random_uniform(100)/100.0f;
    
    UIColor *newColor = [UIColor colorWithRed:r green:g blue:b alpha:alpha];
    cell.color = newColor;
    
    XCTAssertEqualObjects(cell.accessibilityLabel, [newColor description], @"Accessibility label should be %@", [newColor description]);
}


@end
