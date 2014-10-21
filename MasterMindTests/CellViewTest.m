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
    
    UIColor *newColor = [self generateRandomColor];
    cell.color = newColor;
    
    XCTAssertEqualObjects(cell.accessibilityLabel, [newColor description], @"Accessibility label should be %@", [newColor description]);
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

- (void)testBezierPathIsCalledWhenDrawRectIsCalled {

    id cellMock = OCMPartialMock(cell);
    
    OCMStub([cellMock bezierPath]).andForwardToRealObject;
    
    [cell drawRect:cell.bounds];
    
    OCMVerify([cellMock bezierPath]);
}

- (void)testFillIsCalledOnBezierPathWhenDrawRectIsCalled
{
    id bezierMock = OCMPartialMock(cell.bezierPath);
    
    OCMStub([bezierMock fill]).andForwardToRealObject;
    
    [cell drawRect:cell.bounds];
    
    OCMVerify([bezierMock fill]);
}

- (void)testSetFillIsCalledOnColorWhenDrawRectIsCalled
{
    id colorMock = OCMPartialMock(cell.color);
    
    OCMStub([colorMock setFill]).andForwardToRealObject;
    
    [cell drawRect:cell.bounds];
    
    OCMVerify([colorMock setFill]);
}

- (void)testViewMatchesExpectedImage
{

    cell.color = [UIColor redColor];
    cell.frame = CGRectMake(0, 0, 200, 200);
    
    XCTAssertEqualObjects([self dataForCellPNGRepresentation], [self dataForImageWithName:@"testImageRed"], @"View should look like the image");
}

- (void)testChangingColorGeneratesAValidView
{
    cell.color = [UIColor redColor];
    cell.frame = CGRectMake(0, 0, 200, 200);
    XCTAssertEqualObjects([self dataForCellPNGRepresentation], [self dataForImageWithName:@"testImageRed"], @"View should look like the image");
    cell.color = [UIColor blueColor];
    
    XCTAssertEqualObjects([self dataForCellPNGRepresentation], [self dataForImageWithName:@"testImageBlue200x200"], @"View should look like the image");
    
}

- (void)testChangingSizeGeneratesAValidView
{
    cell.color = [UIColor blueColor];
    cell.frame = CGRectMake(0, 0, 200, 200);
    XCTAssertEqualObjects([self dataForCellPNGRepresentation], [self dataForImageWithName:@"testImageBlue200x200"], @"View should look like the image");

    cell.frame = CGRectMake(0, 0, 100, 100);
    
    XCTAssertEqualObjects([self dataForCellPNGRepresentation], [self dataForImageWithName:@"testImageBlue100x100"], @"View should look like the image");
    
}

@end
