//
//  ResultViewTest.m
//  MasterMind
//
//  Created by Guillem Fernández González on 22/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "NSString+Test.h"

#import "MMResultCell.h"

@interface MMResultCell(test)

- (void)drawResultWithBallOffset:(CGPoint)offset;
- (void)drawBallAtContext:(CGContextRef)context withType:(NSNumber *)type atOffset:(NSValue *)voffset withSize:(NSValue *)vsize innerOffset:(NSValue *)vinnerOffset;

@end

@interface ResultViewTest : XCTestCase
{
    MMResultCell *resultCell;
}

@end

@implementation ResultViewTest

- (void)setUp {
    [super setUp];

    resultCell = [[MMResultCell alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// Helper Methods
- (NSString *)generateRandomCharString
{
    // Available symbols
    NSString *symbols = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    // Pick a random index to extract two symbols
    int symbolIndex = arc4random_uniform((int)symbols.length-1);

    // Obtain the two random symbols
    NSString *symbol = [symbols substringWithRange:NSMakeRange(symbolIndex, 1)];
    
    // Obtain random number of each symbols
    int length = arc4random_uniform(10)+1;
    
    NSMutableString *resultString = [NSMutableString stringWithString:@""];
    
    for (int n=1; n<length; n++)
        [resultString appendString:symbol];
    
    return [resultString copy];
    
}

- (NSString *)generateRandomResult
{
    NSMutableString *resultString;
    do {
        resultString = [[self generateRandomCharString] mutableCopy];
    } while (resultString.length == 0);
    
    return [[resultString stringByAppendingString:[self generateRandomCharString]] copy];
}

- (NSData *)dataForCellPNGRepresentationForView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image1);
}

// Test Methods

- (void)testSetColorCallsSetNeedsDisplay
{
    id mockSut = [OCMockObject partialMockForObject:resultCell];
    
    [mockSut setColor:[UIColor redColor]];
    
    OCMVerify([mockSut setNeedsDisplay]);
    
}

- (void)testCellOnInitBackgroundIsTransparent {
    
    XCTAssertEqual(resultCell.backgroundColor, [UIColor clearColor]);
}

- (void)testOnInitResultViewResultValueIsEmpty
{
    XCTAssertEqualObjects(resultCell.result , @"");
}

- (void)testOnResultChangeBezierPathChanges
{
    id resultMock = [OCMockObject partialMockForObject:resultCell];
    resultCell.result = [self generateRandomResult];

    OCMVerify([resultMock setNeedsDisplay]);

    // Force draw rect
    [resultCell drawRect:resultCell.bounds];

    OCMVerify([resultMock drawResultWithBallOffset:CGPointMake(3, 3)]);
}

- (void)testOnResultChangeToEmptyBezierPathsContainsZeroCircles
{
    id resultMock = [OCMockObject partialMockForObject:resultCell];
    __block int callCount = 0;
    OCMStub([resultMock drawBallAtContext:[OCMArg anyPointer]
                                 withType:[OCMArg isKindOfClass:[NSNumber class]]
                                 atOffset:[OCMArg isKindOfClass:[NSValue class]]
                                 withSize:[OCMArg isKindOfClass:[NSValue class]]
                              innerOffset:[OCMArg isKindOfClass:[NSValue class]]]).andDo(^(NSInvocation *invocation) {
        ++callCount;
    }).andForwardToRealObject;
    
    resultCell.result = @"";
    // Force draw rect
    [resultCell drawRect:resultCell.bounds];
    
    XCTAssertEqual(callCount, 0);
}

- (void)testOnResultChangeSameNumberOfCirclesAsTheLengthOfResultIsGenerated
{
    id resultMock = [OCMockObject partialMockForObject:resultCell];
    __block int callCount = 0;
    OCMStub([resultMock drawBallAtContext:[OCMArg anyPointer]
                                 withType:[OCMArg isKindOfClass:[NSNumber class]]
                                 atOffset:[OCMArg isKindOfClass:[NSValue class]]
                                 withSize:[OCMArg isKindOfClass:[NSValue class]]
                              innerOffset:[OCMArg isKindOfClass:[NSValue class]]]).andDo(^(NSInvocation *invocation) {
        ++callCount;
    }).andForwardToRealObject;

    int len = arc4random_uniform(3)+1;
    resultCell.result = [NSString randomStringWithLength:len];
    [resultCell drawRect:resultCell.bounds];

    NSLog(@"result: %@", resultCell.result);
    XCTAssertEqual(callCount, resultCell.result.length);
    
}

- (void)testIfNewResultHasMoreThanTwoDifferentSymbolsOnlyFirstTwoAreObtained
{
    
    // Generate a random combination
    NSString *resultLeftSide = [self generateRandomResult];
    NSString *newResult = [resultLeftSide copy];

    // Generate a variable string with different characters
    int randomNStrings = arc4random_uniform(10) + 1;

    for (int n=1; n<randomNStrings; n++) {
         newResult = [newResult stringByAppendingString:[self generateRandomCharString]];
    }
    
    resultCell.result = newResult;
    
    XCTAssertEqualObjects(resultCell.result, resultLeftSide, @"%@ should produce %@ but produced %@", newResult, resultLeftSide, resultCell.result);
    
}

- (void)testIfNewResultHasOnlyOneSymbolByDefaultAreFirstSymbol
{
    
    id resultMock = [OCMockObject partialMockForObject:resultCell];
    __block int callCount = 0;
    OCMStub([resultMock drawBallAtContext:[OCMArg anyPointer]
                                 withType:@0
                                 atOffset:[OCMArg isKindOfClass:[NSValue class]]
                                 withSize:[OCMArg isKindOfClass:[NSValue class]]
                              innerOffset:[OCMArg isKindOfClass:[NSValue class]]]).andDo(^(NSInvocation *invocation) {
        ++callCount;
    }).andForwardToRealObject;
    
    resultCell.result = [self generateRandomCharString];
    
    // Force redraw
    [resultCell drawRect:resultCell.bounds];
    
    if (resultCell.result.length >= 4) {
        XCTAssertEqual(callCount, 4);
    } else {
        XCTAssertEqual(callCount, resultCell.result.length);
    }
}

- (void)testIfNewResultHasASingleAsFirstSymbolAllSymbolsAreSecondary
{
    
    id resultMock = [OCMockObject partialMockForObject:resultCell];
    __block int callCount = 0;
    OCMStub([resultMock drawBallAtContext:[OCMArg anyPointer]
                                 withType:@1
                                 atOffset:[OCMArg isKindOfClass:[NSValue class]]
                                 withSize:[OCMArg isKindOfClass:[NSValue class]]
                              innerOffset:[OCMArg isKindOfClass:[NSValue class]]]).andDo(^(NSInvocation *invocation) {
        ++callCount;
    }).andForwardToRealObject;

    resultCell.result = [NSString stringWithFormat:@" %@",[self generateRandomCharString]];
    
    // Force redraw
    [resultCell drawRect:resultCell.bounds];
    
    if (resultCell.result.length >= 4) {
        XCTAssertEqual(callCount, 4);
    } else {
        XCTAssertEqual(callCount, resultCell.result.length);
    }
}


@end
