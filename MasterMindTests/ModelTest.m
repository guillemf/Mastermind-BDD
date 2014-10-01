//
//  ModelTest.m
//  MasterMind
//
//  Created by Guillem Fernández González on 30/09/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MMModel.h"

@interface ModelTest : XCTestCase

@end

@implementation ModelTest
{
    MMModel *model;
}

- (void)setUp {
    [super setUp];
    
    model = [[MMModel alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testModelOnInitContainsACombination {
    
    XCTAssertNotNil(model.combination, @"A model should always have a combination");
}

- (void)testModelOnStartShouldGenerateANewCombination {
    
    int lowerBound = 1;
    int upperBound = 5;
    
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    
    for (int n= 1; n<=rndValue; n++) {
        
        NSString *originalCombination = model.combination;
        [model start];
        XCTAssertNotEqual(originalCombination, model.combination, @"After start the combination has to be different from the previous one");

    }
}

- (void)testModelSecretCombinationShouldContainFourNumbers
{
    XCTAssertEqual(model.combination.length, 4ul, @"Secrect combination length should be four");
}

- (void)testModelSecretCombinationIsNumeric
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [model.combination rangeOfCharacterFromSet: nonNumbers];
    [model start];
    
    XCTAssertEqual(r.location, NSNotFound, @"All digits should be numeric");
}

@end
