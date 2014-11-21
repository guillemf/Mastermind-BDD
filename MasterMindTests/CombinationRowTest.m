//
//  CombinationRowTest.m
//  MasterMind
//
//  Created by Guillem Fernández González on 11/11/14.
//  Copyright (c) 2014 Guillem Fern√°ndez Gonz√°lez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MMResultCell.h"
#import "MMCombinationRow.h"
#import "MMCell.h"
#import "MMProtocols.h"
#import "NSString+Test.h"
#import "NSArray+Test.h"
#import "MMViewController.h"

#import <objc/runtime.h>

@interface MMCombinationRow(testCategory)

- (void)changeColor:(UITapGestureRecognizer *)gesture;
- (void)checkCombination:(UISwipeGestureRecognizer *)gesture;
- (void)callVerify;

// Helper methods for testing
- (MMCell *)cellAtPosition:(int)position;
- (void)simulateTapInCellAtPosition:(int)position;

@property (nonatomic, readonly) MMResultCell *resultCell;

@end

#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation MMCombinationRow(testCategory)

@dynamic resultCell;

- (MMCell *)cellAtPosition:(int)position
{
    MMCell *returnCell = nil;
    int currentCell = 1;
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[MMCell class]]) {
            if (currentCell == position) {
                returnCell = (MMCell *)view;
                break;
            } else {
                currentCell++;
            }
        }
    }
    
    return returnCell;
}

- (void)simulateTapInCellAtPosition:(int)position
{
    id gestureMock = [OCMockObject mockForClass:[UITapGestureRecognizer class]];
    OCMStub([gestureMock view]).andReturn([self cellAtPosition:position]);
    [self changeColor:gestureMock];
}

@end

@interface CombinationRowTest : XCTestCase
{
    MMCombinationRow *row;
    id delegateObject;
}

@end

@implementation CombinationRowTest


- (void)simulateTapInRow:(MMCombinationRow *)combination onCell:(MMCell *)cell
{
    for (MMCell *subview in combination.subviews) {
        if (subview == cell) {
            id gestureMock = [OCMockObject mockForClass:[UITapGestureRecognizer class]];
            OCMStub([gestureMock view]).andReturn(subview);
            [combination changeColor:gestureMock];
            }
    }

}

- (id)extractTarget:(UIGestureRecognizer *)gesture
{
    Ivar targetsIvar = class_getInstanceVariable([UIGestureRecognizer class], "_targets");
    id targetActionPairs = object_getIvar(gesture, targetsIvar);
    Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
    Ivar targetIvar = class_getInstanceVariable(targetActionPairClass, "_target");
    
    id target = nil;
    
    for (id targetActionPair in targetActionPairs)
    {
        target = object_getIvar(targetActionPair, targetIvar);
        break;
    }
    
    return target;
}

- (SEL)extractAction:(UIGestureRecognizer *)gesture
{
    Ivar targetsIvar = class_getInstanceVariable([UIGestureRecognizer class], "_targets");
    id targetActionPairs = object_getIvar(gesture, targetsIvar);
    Class targetActionPairClass = NSClassFromString(@"UIGestureRecognizerTarget");
    Ivar actionIvar = class_getInstanceVariable(targetActionPairClass, "_action");
    
    SEL action = nil;
    
    for (id targetActionPair in targetActionPairs)
    {
        action = (__bridge void *)object_getIvar(targetActionPair, actionIvar);
        break;
    }
    
    return action;
}

- (void)setUp {
    [super setUp];
    row = [[MMCombinationRow alloc] init];
    delegateObject = OCMProtocolMock(@protocol(CombinationCellDelegate));
    OCMStub([delegateObject isRowActive:row]).andReturn(YES);
    row.delegate = delegateObject;

}

- (void)tearDown {

    delegateObject = nil;
    row = nil;
    [super tearDown];
}

- (void)testOnInitCombinationRowContainsOneResultView
{
    int nResults = 0;
    
    for (UIView *subview in row.subviews)
        if ([subview isKindOfClass:[MMResultCell class]]) nResults++;
    
    XCTAssertEqual(nResults, 1, @"Combination Row should contain exactly one result cell");
}

- (void)testOnInitCombinationRowContainsFourCellViews
{
    int nResults = 0;
    
    for (UIView *subview in row.subviews)
        if ([subview isKindOfClass:[MMCell class]]) nResults++;
    
    XCTAssertEqual(nResults, 4, @"Combination Row should contain exactly four cells");
}

- (void)testAllCellsAreTheSameWidth
{
    float expectedWidth = arc4random_uniform(50);
    row.frame = CGRectMake(0, 0, expectedWidth*5, arc4random_uniform(300));
    [row layoutIfNeeded];

    for (UIView *subview in row.subviews)
        XCTAssertEqual(expectedWidth, ceil(subview.frame.size.width), @"All cells should be the same width");
}

- (void)testAllCellsAreTheSameHeigthAsTheRow
{
    row.frame = CGRectMake(0, 0, arc4random_uniform(300), arc4random_uniform(300));
    [row layoutIfNeeded];

    float expectedHeigth = row.frame.size.height;
    
    for (UIView *subview in row.subviews)
        XCTAssertEqual(expectedHeigth, subview.frame.size.height, @"All cells should be the same heigth as the row");
}

- (void)testBackgroundColorIsWhite
{
    XCTAssertEqualObjects(row.backgroundColor, [UIColor whiteColor], @"Background color should be white");
}

- (void)testBotomBorderLayoutIsPresent
{
    CALayer *borderLayer = row.layer.sublayers[0];
    row.frame = CGRectMake(0, 0, arc4random_uniform(300), arc4random_uniform(300));
    [row layoutIfNeeded];
    
    XCTAssertNotNil(borderLayer, @"Row should contain at least a sublayer");
    XCTAssertEqual(borderLayer.borderWidth, 1, @"Row should have 1p border width");
    XCTAssertEqual(borderLayer.frame.origin.x, 0, @"Border should start at position 0 not %f", borderLayer.frame.origin.x);
    XCTAssertEqual(borderLayer.frame.origin.y, row.bounds.size.height-1, @"Border should start at position %f not %f", row.bounds.size.height-1, borderLayer.frame.origin.x);
    XCTAssertEqual(borderLayer.frame.size.width, row.bounds.size.width, @"Border should be %f width not %f", row.bounds.size.width, borderLayer.frame.size.width);
    XCTAssertEqual(borderLayer.frame.size.height, 1, @"Border should be 1 pixel height, not %f", borderLayer.frame.size.height);

}

- (void)testLeftBorderLayoutIsPresent
{
    CALayer *borderLayer = row.layer.sublayers[1];
    row.frame = CGRectMake(0, 0, arc4random_uniform(300), arc4random_uniform(300));
    [row layoutIfNeeded];
    float expectedX = round(row.bounds.size.width/5);
    
    XCTAssertNotNil(borderLayer, @"Row should contain at least a sublayer");
    XCTAssertEqual(borderLayer.borderWidth, 1, @"Row should have 1p border width");
    XCTAssertEqual(borderLayer.frame.origin.x, expectedX, @"Border should start at position %f not %f", expectedX, borderLayer.frame.origin.x);
    XCTAssertEqual(borderLayer.frame.origin.y, 0, @"Border should start at position 0 not %f", borderLayer.frame.origin.x);
    XCTAssertEqual(borderLayer.frame.size.height, row.bounds.size.height, @"Border should be %f width not %f", row.bounds.size.height, borderLayer.frame.size.height);
    XCTAssertEqual(borderLayer.frame.size.width, 1, @"Border should be 1 pixel height, not %f", borderLayer.frame.size.width);
    
}

- (void)testTapingOnViewCallschangeColor
{

    for (MMCell *subview in row.subviews) {
        if ([subview isKindOfClass:[MMCell class]]) {
            [self simulateTapInRow:row onCell:(MMCell*)subview];
            
            XCTAssertEqualObjects(subview.color, [UIColor redColor], @"Cell color should be red");
        }
    }
}

- (void)testSwipeGestureIsAdded
{
    UISwipeGestureRecognizer *swipe = nil;
    
    for (UIGestureRecognizer *gesture in row.gestureRecognizers) {
        if ([gesture isKindOfClass:[UISwipeGestureRecognizer class]]) {
            swipe = (UISwipeGestureRecognizer *)gesture;
        }
    }

    XCTAssertNotNil(swipe, @"Swipe gesture should be added");
    
    id target = [self extractTarget:swipe];
    XCTAssertNotNil(target, @"Swipe gesture should be pointing row");

    SEL action = [self extractAction:swipe];
    XCTAssertEqual(action, @selector(checkCombination:));

}

- (void)testCheckCombinationIsNeverCalledWhenAnyRowIsClear
{
    NSArray *blankRows = [NSArray generateRandomListOfRows];
    int rowNumber = 0;
    id rowMock = [OCMockObject partialMockForObject:row];
    OCMStub([rowMock callVerify]).andDo(^(NSInvocation *invocation)
                                              { XCTFail(@"This method should never be called");
                                              });
    
    for (MMCell *subview in row.subviews) {
        if ([subview isKindOfClass:[MMCell class]]) {
            
            if (![blankRows containsObject:[NSNumber numberWithInt:rowNumber]]) {
                [self simulateTapInRow:row onCell:(MMCell*)subview];
            }
            rowNumber++;
        }
    }
    
    id gestureMock = [OCMockObject mockForClass:[UISwipeGestureRecognizer class]];
    OCMStub([gestureMock view]).andReturn(row);
    
    [row checkCombination:gestureMock];
    
}

- (void)testCheckCombinationIsCalledeWhenAllRowsAreTaped
{
    NSArray *doubleTapRows = [NSArray generateRandomListOfRows];
    int rowNumber = 0;
    id rowMock = [OCMockObject partialMockForObject:row];
    
    for (MMCell *subview in row.subviews) {
        if ([subview isKindOfClass:[MMCell class]]) {
            [self simulateTapInRow:row onCell:(MMCell*)subview];
            if (![doubleTapRows containsObject:[NSNumber numberWithInt:rowNumber]]) {
                [self simulateTapInRow:row onCell:(MMCell*)subview];
            }
            rowNumber++;
        }
    }
    
    id gestureMock = [OCMockObject mockForClass:[UISwipeGestureRecognizer class]];
    OCMStub([gestureMock view]).andReturn(row);
    
    [rowMock checkCombination:gestureMock];
    
    OCMVerify([rowMock callVerify]);
}

- (void)testCallVerfyWillCallDelegateVerify
{
    
    [row callVerify];
    
    OCMVerify([delegateObject checkCombinationFor:row]);
    
}

- (void)testCombinationPropertyReflectsRealValues
{
    // Simulate random number of taps in row
    int tapsOnFirst = arc4random_uniform(3)+1;
    int tapsOnSecond = arc4random_uniform(3)+1;
    int tapsOnThird = arc4random_uniform(3)+1;
    int tapsOnFourth = arc4random_uniform(3)+1;
    
    NSString *expectedCombination = [NSString stringWithFormat:@"%d%d%d%d",
                                     tapsOnFirst,
                                     tapsOnSecond,
                                     tapsOnThird,
                                     tapsOnFourth];
    NSLog(@"Combination: %d-%d-%d-%d", tapsOnFirst, tapsOnSecond, tapsOnThird, tapsOnFourth);
    
    for (int n=0; n<tapsOnFirst; n++) {
        [row simulateTapInCellAtPosition:1];
    }

    for (int n=0; n<tapsOnSecond; n++) {
        [row simulateTapInCellAtPosition:2];
    }

    for (int n=0; n<tapsOnThird; n++) {
        [row simulateTapInCellAtPosition:3];
    }

    for (int n=0; n<tapsOnFourth; n++) {
        [row simulateTapInCellAtPosition:4];
    }
    
    XCTAssertEqualObjects(row.combination, expectedCombination);
}

- (void)testSetResultCallsSetResultOnResultCell
{
    MMResultCell *resCell = [OCMockObject partialMockForObject:row.resultCell];
    NSString *combination = [NSString generateValidCombination];
    
    [row setResult:combination];
    
    OCMVerify([resCell setResult:combination]);
}


@end
