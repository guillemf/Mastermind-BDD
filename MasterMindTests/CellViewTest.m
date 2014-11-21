//
//  CellViewTest.m
//  MasterMind
//
//  Created by Guillem Fernández González on 20/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "MMCell.h"

@interface MMCell(test)

- (void)drawShapeWithSize:(NSValue *)vsize offset:(NSNumber *)voffset;

@end

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

- (NSData *)dataForImageWithName:(NSString *)imageName
{
    NSString* fileImageName = [[NSBundle bundleForClass:[self class]] pathForResource:imageName ofType:@"png"];
    UIImage *fileImageObj = [[UIImage alloc] initWithContentsOfFile:fileImageName];
    return UIImagePNGRepresentation(fileImageObj);
}

- (NSData *)dataForCellPNGRepresentation
{
    UIGraphicsBeginImageContext(cell.bounds.size);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImagePNGRepresentation(image1);
}

- (UIColor *)generateRandomColor
{
    float r = arc4random_uniform(255)/255.0f;
    float g = arc4random_uniform(255)/255.0f;
    float b = arc4random_uniform(255)/255.0f;
    float alpha = arc4random_uniform(100)/100.0f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

- (void)testCellOnInitBackgroundIsTransparent {
    
    XCTAssertEqual(cell.backgroundColor, [UIColor clearColor]);
}

- (void)testCellOnInitColorIsTransparent {
    
    XCTAssertEqual(cell.color, [UIColor clearColor]);
}

- (void)testAccessibilityShouldBeEnabled {
    
    XCTAssertTrue([cell isAccessibilityElement], @"View accessibility should be enabled");
}

- (void)testWhenCellChangesColorViewIsRedrawn {
    
    id cellMock = OCMPartialMock(cell);
    
    OCMStub([cellMock setNeedsDisplay]).andForwardToRealObject;
    
    cell.color = [self generateRandomColor];
    
    OCMVerify([cellMock setNeedsDisplay]);
}

- (void)testWhenCellChangesFrameViewIsRedrawn {
    
    id cellMock = OCMPartialMock(cell);
    
    OCMStub([cellMock setNeedsDisplay]).andForwardToRealObject;
    
    cell.frame = CGRectMake(0, 0, 200, 200);
    
    OCMVerify([cellMock setNeedsDisplay]);
}

- (void)testDrawShapeIsCalledWhenDrawRectIsCalled {

    id cellMock = OCMPartialMock(cell);
    
    OCMStub([cellMock drawShapeWithSize:[OCMArg any] offset:[OCMArg any]]).andForwardToRealObject;
    
    [cell drawRect:cell.bounds];
    
    OCMVerify([cellMock drawShapeWithSize:[OCMArg any] offset:[OCMArg any]]);
}

- (void)testSetFillIsCalledOnColorWhenDrawRectIsCalled
{
    id colorMock = OCMPartialMock(cell.color);
    
    OCMStub([colorMock setFill]).andForwardToRealObject;
    
    [cell drawRect:cell.bounds];
    
    OCMVerify([colorMock setFill]);
}

- (void)testChangingColorGeneratesAValidView
{
    id cellMock = OCMPartialMock(cell);

    __block int callCount = 0;
    OCMStub([cellMock setNeedsDisplay]).andDo(^(NSInvocation *invocation) {
        ++callCount;
    }).andForwardToRealObject;
    
    cell.color = [UIColor redColor];
    
    cell.color = [UIColor blueColor];
    
    XCTAssert(callCount == 2);
    
}

- (void)testChangingSizeGeneratesAValidView
{
    cell.color = [UIColor blueColor];

    id cellMock = OCMPartialMock(cell);
    
    __block int callCount = 0;
    OCMStub([cellMock setNeedsDisplay]).andDo(^(NSInvocation *invocation) {
        ++callCount;
    }).andForwardToRealObject;
    
    cell.frame = CGRectMake(0, 0, 200, 200);

    cell.frame = CGRectMake(0, 0, 100, 100);
    
    XCTAssert(callCount == 2);
    
}

@end
