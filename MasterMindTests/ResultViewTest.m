//
//  ResultViewTest.m
//  MasterMind
//
//  Created by Guillem Fernández González on 22/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "MMResultCell.h"

// Dummy view to draw the image we expect

@interface DummyView : UIView

@property (nonatomic, strong) NSString *combination;
@property (nonatomic, strong) UIColor *color;

@end

@implementation DummyView

- (id)initWithFrame:(CGRect)frame combination:(NSString *)combination color:(UIColor *)color
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.combination = combination;
        self.color = color;
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Obtain first char
    unichar leftchar = [self.combination characterAtIndex:0];
    NSString *combination = [self.combination stringByReplacingOccurrencesOfString:@" " withString:@""];
    // Obtain rectangle ration
    float K = rect.size.height/rect.size.width;
    // Obtain number of items
    long N = combination.length;
    
    // Obtain grid sizes
    float verItems = ceil(sqrtf(K*N));
    float horItems = ceil(sqrtf(N/K));
    
    // Items horizontally
    float gridHeigh = rect.size.height / verItems;
    float gridWidth = rect.size.width / horItems;
    
    // Draw circles
    [self.color setFill];
    [self.color setStroke];
    
    UIBezierPath *bezPath;
    int currentElement;
    
    for (int y = 0; y<verItems; y++) {
        for (int x = 0; x<horItems; x++) {
            currentElement = (horItems*y)+x ;
            if (currentElement >= N) {
                break;
            }
            bezPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(x*gridWidth, y*gridHeigh, gridWidth, gridHeigh)];
            if ([combination characterAtIndex:currentElement] == leftchar) {
                [bezPath fill];
            } else {
                [bezPath stroke];
            }
        }
    }
}


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
    int length = arc4random_uniform(10);
    
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

- (void)testCellOnInitBackgroundIsTransparent {
    
    XCTAssertEqual(resultCell.backgroundColor, [UIColor clearColor]);
}

- (void)testOnInitResultViewResultValueIsEmpty
{
    XCTAssertEqualObjects(resultCell.result , @"");
}

- (void)testOnResultChangeBezierPathChanges
{
    NSArray *currentBeziers = resultCell.bezierPaths;
    resultCell.result = [self generateRandomResult];
    // Force draw rect
    [resultCell drawRect:resultCell.bounds];

    XCTAssertNotEqual(currentBeziers, resultCell.bezierPaths, @"Bezier Path list should be updated");
}

- (void)testOnResultChangeToEmptyBezierPathsContainsZeroCircles
{
    XCTAssertEqual(resultCell.bezierPaths.count, 0);
}

- (void)testOnResultChangeBezierPathsContainsSameNumberOfCirclesAsTheLengthOfResultWithOneSymbol
{
    resultCell.result = [self generateRandomCharString];
    [resultCell drawRect:resultCell.bounds];

    XCTAssertEqual(resultCell.bezierPaths.count, resultCell.result.length);
    
}

- (void)testOnResultChangeBezierPathsContainsSameNumberOfCirclesAsTheLengthOfResult
{
    resultCell.result = [self generateRandomResult];
    [resultCell drawRect:resultCell.bounds];

    XCTAssertEqual(resultCell.bezierPaths.count, resultCell.result.length);
    
}

- (void)testIfNewResultHasMoreThanTwoDifferentSymbolsOnlyFirstTwoAreObtained
{
    
    // Generate a random combination
    NSString *resultLeftSide = [self generateRandomResult];
    NSString *newResult = resultLeftSide;

    // Generate a variable string with different characters
    int randomNStrings = arc4random_uniform(10) + 1;

    for (int n=1; n<randomNStrings; n++) {
         newResult = [newResult stringByAppendingString:[self generateRandomCharString]];
    }
    
    resultCell.result = newResult;
    
    XCTAssertEqualObjects(resultCell.result, resultLeftSide, @"%@ should produce %@ but produced %@", newResult, resultLeftSide, resultCell.result);
    
}

- (void)testOnResultChangeBezierPathsContainsOnlyBezierPaths
{
    resultCell.result = [self generateRandomResult];
    
    for (id bezier in resultCell.bezierPaths) {
        XCTAssertEqualObjects([bezier class], [UIBezierPath class], @"All objects in bezier paths have to be Bezier Paths");
    }
}

- (void)testOnResultChangeGeneratedViewMatchesExpectedView
{
    resultCell.result = [self generateRandomResult];
    resultCell.frame = CGRectMake(0, 0, arc4random_uniform(300), arc4random_uniform(300));
    
    DummyView *dummyV = [[DummyView alloc] initWithFrame:resultCell.frame
                                             combination:resultCell.result
                                                   color:resultCell.color];
    
    NSData *expectedImage = [self dataForCellPNGRepresentationForView:dummyV];

    NSData *obtainedImage = [self dataForCellPNGRepresentationForView:resultCell];
    
    
    XCTAssertEqualObjects(expectedImage, obtainedImage);
}

- (void)testIfNewResultHasOnlyOneSymbolByDefaultAreFirstSymbol
{
    resultCell.result = [self generateRandomCharString];
    resultCell.frame = CGRectMake(0, 0, arc4random_uniform(300), arc4random_uniform(300));
    
    DummyView *dummyV = [[DummyView alloc] initWithFrame:resultCell.frame
                                             combination:resultCell.result
                                                   color:resultCell.color];
    
    NSData *expectedImage = [self dataForCellPNGRepresentationForView:dummyV];
    
    NSData *obtainedImage = [self dataForCellPNGRepresentationForView:resultCell];
    
    
    XCTAssertEqualObjects(expectedImage, obtainedImage);
}

- (void)testIfNewResultHasASingleAsFirstSymbolAllSymbolsAreSecondary
{
    resultCell.result = [NSString stringWithFormat:@" %@",[self generateRandomCharString]];
    resultCell.frame = CGRectMake(0, 0, arc4random_uniform(300), arc4random_uniform(300));
    
    DummyView *dummyV = [[DummyView alloc] initWithFrame:resultCell.frame
                                             combination:resultCell.result
                                                   color:resultCell.color];
    
    NSData *expectedImage = [self dataForCellPNGRepresentationForView:dummyV];
    
    NSData *obtainedImage = [self dataForCellPNGRepresentationForView:resultCell];
        
    XCTAssertEqualObjects(expectedImage, obtainedImage);
}


@end
