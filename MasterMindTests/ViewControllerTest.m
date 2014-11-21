//
//  ViewControllerTest.m
//  MasterMind
//
//  Created by Guillem Fernández González on 09/02/15.
//  Copyright (c) 2015 Guillem Fern√°ndez Gonz√°lez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MMViewController.h"
#import "MMCombinationRow.h"
#import "MMModel.h"
#import "NSString+Test.h"

@interface MMViewController(test)

@property (nonatomic, readonly) MMModel *model;

- (void)checkCombinationFor:(MMCombinationRow *)row;
- (void)newGame;

@end

@interface ViewControllerTest : XCTestCase
{
    MMViewController *sut;
}

@end

@interface MMCombinationRow(testVC)

- (void)checkCombination:(UISwipeGestureRecognizer *)gesture;
- (BOOL)isComplete;

@end

@implementation ViewControllerTest

- (void)setUp {
    [super setUp];
    sut = [[MMViewController alloc] init];
    
    UIView *forceCreate = sut.view;
    #pragma unused(forceCreate)
}

- (void)tearDown {
    sut = nil;
    [super tearDown];
}

- (void)testAfterInitAllSubviewsAreCombinationRows
{
    for (UIView *subView in sut.view.subviews) {
        XCTAssert([subView isKindOfClass:[MMCombinationRow class]], @"All subviews should be combination rows");
    }
}

- (void)testThatAfterInitTheNumberOfResultViewIsNine
{
    int totalResult = 0;
    
    for (UIView *subView in sut.view.subviews)
    {
        #pragma unused(subView)
        totalResult++;
    }
    
    XCTAssertEqual(totalResult, 9, @"The view should contain exaclty nine result cells instead of %d", totalResult);
    
}

- (void)testAllRowsAreTheSameHeigthAsTheRow
{
    
    float expectedHeigth = -1;
    
    for (UIView *subview in sut.view.subviews)
    {
        if (expectedHeigth == -1) {
            
            expectedHeigth = subview.bounds.size.height;
        } else {
            XCTAssertEqual(expectedHeigth, subview.bounds.size.height, @"All rows should be the same heigth");
        }
    }
}

- (void)testDelegateMethodsAreImplemented
{
    XCTAssertTrue([sut respondsToSelector:@selector(checkCombinationFor:)]);
}

- (void)testAllRowsHaveSutAsDelegate
{
    for (UIView *subview in sut.view.subviews)
    {
        MMCombinationRow *row;
        if ([subview isKindOfClass:[MMCombinationRow class]]) {
            row = (MMCombinationRow *)subview;
            XCTAssertEqual((MMViewController *)row.delegate, sut, @"All rows should have sut as delegate");
        }
    }
}

- (void)testCallingCheckCombinationReturnsResultIfRowIsActive
{
    MMCombinationRow *testRow = OCMClassMock([MMCombinationRow class]);
    id sutMock = [OCMockObject partialMockForObject:sut];
    OCMStub([sutMock isRowActive:testRow]).andReturn(YES);
    
    [sut checkCombinationFor:testRow];
    
    OCMVerify([testRow setResult:[OCMArg any]]);
}

- (void)testCallingCheckCombinationDoesNotReturnsResultIfRowIsNotActive
{
    MMCombinationRow *testRow = OCMClassMock([MMCombinationRow class]);
    id sutMock = [OCMockObject partialMockForObject:sut];
    OCMStub([sutMock isRowActive:testRow]).andReturn(NO);
    
    id rowMock = [OCMockObject partialMockForObject:testRow];
    __block int callCount = 0;
    OCMStub([rowMock setResult:[OCMArg isKindOfClass:[NSString class]]]).andDo(^(NSInvocation *invocation) {
        ++callCount;
    });

    [sut checkCombinationFor:testRow];
    
    XCTAssert(callCount == 0);
}


- (void)testOnInitModelIsCreated
{
    XCTAssertNotNil(sut.model, @"Model should be initialized");
}

- (void)testNewMatchIsCalledOnInit
{
    MMViewController *sut2 = [[MMViewController alloc] init];
    MMViewController *mockSut2 = [OCMockObject partialMockForObject:sut2];
    
    UIView *view = sut2.view;
    #pragma unused(view)

    OCMVerify([mockSut2 newGame]);
}

- (void)testOnNewMatchStartIsCalledInModel
{
    MMModel *model = [OCMockObject partialMockForObject:sut.model];

    [sut newGame];
    
    OCMVerify([model start]);

}

- (void)testCallingCheckCombinationCallsAddAttemptInModel
{
    id modelMock = [OCMockObject partialMockForObject:sut.model];
    MMCombinationRow *testRow = OCMClassMock([MMCombinationRow class]);
    NSString *combination = [NSString generateValidCombination];
    OCMStub([testRow combination]).andReturn(combination);
    
    id sutMock = [OCMockObject partialMockForObject:sut];
    OCMStub([sutMock isRowActive:testRow]).andReturn(YES);

    [sut checkCombinationFor:testRow];
    
    OCMVerify([modelMock addAttempt:combination]);
    
}

- (void)testCallingCheckCombinationSetsModelResultInRow
{
    id modelMock = [OCMockObject partialMockForObject:sut.model];
    NSString *result = [NSString generateValidResult];
    OCMStub([modelMock addAttempt:[OCMArg isKindOfClass:[NSString class]]]).andReturn(result);
    
    MMCombinationRow *testRow = OCMClassMock([MMCombinationRow class]);
    OCMStub([testRow combination]).andReturn(@"1234");
    
    id sutMock = [OCMockObject partialMockForObject:sut];
    OCMStub([sutMock isRowActive:testRow]).andReturn(YES);
    
    [sut checkCombinationFor:testRow];
    
    OCMVerify([testRow setResult:result]);
    
}

- (void)testCombinationForRowIsCalledFromSubView
{
    // Prepare row
    MMCombinationRow *testRow = [[MMCombinationRow alloc] init];
    id rowMock = [OCMockObject partialMockForObject:testRow];
    OCMStub([rowMock isComplete]).andReturn(YES);

    id gestureMock = [OCMockObject mockForClass:[UISwipeGestureRecognizer class]];
    OCMStub([gestureMock view]).andReturn(testRow);
    
    [rowMock checkCombination:gestureMock];

    OCMVerify([sut checkCombinationFor:testRow]);

}

- (void)testCheckCombinationCantBeCalledTwiceForTheSameRow
{
    // Prepare row
    MMCombinationRow *testRow = [sut.view.subviews objectAtIndex:0];
    
    id rowMock = [OCMockObject partialMockForObject:testRow];
    OCMStub([rowMock isComplete]).andReturn(YES);
    NSString *combination = [NSString generateValidCombination];
    OCMStub([rowMock combination]).andReturn(combination);

    id gestureMock = [OCMockObject mockForClass:[UISwipeGestureRecognizer class]];
    OCMStub([gestureMock view]).andReturn(testRow);

    id modelMock = [OCMockObject partialMockForObject:sut.model];
    __block int callCount = 0;
    OCMStub([modelMock addAttempt:[OCMArg isKindOfClass:[NSString class]]]).andDo(^(NSInvocation *invocation) {
        ++callCount;
    }).andForwardToRealObject;

    [rowMock checkCombination:gestureMock];
    [rowMock checkCombination:gestureMock];
    
    int expectedNumberOfCalls = 1;
    XCTAssertEqual(callCount, expectedNumberOfCalls);
    
}
@end
