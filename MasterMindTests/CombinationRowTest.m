//
//  CombinationRowTest.m
//  MasterMind
//
//  Created by Guillem Fernández González on 11/11/14.
//  Copyright (c) 2014 Guillem Fern√°ndez Gonz√°lez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MMResultCell.h"
#import "MMCombinationRow.h"
#import "MMCell.h"

@interface CombinationRowTest : XCTestCase
{
    MMCombinationRow *row;
}

@end

@implementation CombinationRowTest

- (void)setUp {
    [super setUp];
    row = [[MMCombinationRow alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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


@end
