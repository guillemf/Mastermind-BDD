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

#pragma mark - Support methods

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *)randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length]) % [letters length]]];
    }
    
    return randomString;
}

NSString *validValues = @"1234";
int combinationLength = 4;

- (NSString *)generateValidCombination {
    
    NSMutableString *randomSCombination = [NSMutableString stringWithCapacity: combinationLength];
    
    for (int i=0; i<combinationLength; i++) {
        [randomSCombination appendFormat: @"%C", [validValues characterAtIndex: arc4random_uniform((int)[validValues length]) % [validValues length]]];
    }
    
    return randomSCombination;

}

- (NSString *)generateNonWinnerCombination
{
    NSString *testCombination;
    // Check combination is not the right one
    do
    {
        testCombination = [self generateValidCombination];
    } while ([testCombination isEqualToString:model.combination]);

    return testCombination;
}

- (void)testModelOnInitContainsACombination {
    
    XCTAssertNotNil(model.combination, @"A model should always have a combination");
}

# pragma mark - Every time we start a new game, the model has to create a new secret combination.

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

#pragma mark - The secret combination is four numbers long.

- (void)testModelSecretCombinationShouldContainFourNumbers
{
    XCTAssertEqual(model.combination.length, 4ul, @"Secrect combination length should be four");
}

- (void)testModelSecretCombinationIsNumeric
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [model.combination rangeOfCharacterFromSet: nonNumbers];
    
    XCTAssertEqual(r.location, NSNotFound, @"All digits should be numeric");
}

#pragma mark - The numbers in the combination are between 1 and 4.

- (void)testModelSecretCombinationAllDigitsAreBetween1and4
{
    NSCharacterSet* non1234 = [[NSCharacterSet characterSetWithCharactersInString:@"1234"] invertedSet];
    NSRange r = [model.combination rangeOfCharacterFromSet: non1234];
    
    XCTAssertEqual(r.location, NSNotFound, @"All digits should be between 1 and 4");

}

#pragma mark - The numbers in the combination can be repeated.

// No test needs to be done as this is not a restriction

#pragma mark - Every time we start a new game, the number of attempts has to be zero.

- (void)testModelAfterStartHasZeroAttempts
{
    XCTAssertEqual(model.attempts, 0ul, @"The initial number of attempts has to be zero");
}

#pragma mark - The maximum number of attempts is nine.

- (void)testModelNumberOfAttemptsIncrementsWithEachAttempt
{
    [model addAttempt:@"1111"];
    XCTAssertEqual(model.attempts, 1ul, @"The number of attempts has to be increased in one");
    [model addAttempt:@"1111"];
    XCTAssertEqual(model.attempts, 2ul, @"The number of attempts has to be increased in one");

}

- (void)testModelMaximumNumberOfAttemptsIsNine
{
    for (int n= 0; n<10; n++) {
        [model addAttempt:@"1111"];
    }
    
    XCTAssertEqual(model.attempts, 9ul, @"The initial number of attempts has to be zero");

}

- (void)testModelAttemptsAfterNinthFail
{
    for (int n= 0; n<9; n++) {
        XCTAssertNotNil([model addAttempt:@"1111"],@"Valid attempts should be accepted");
    }
    
    XCTAssertNil([model addAttempt:@"1111"], @"All attempts after ninth should fail");
    
}

#pragma mark - Only combinations of four numbers are accepted.

- (void)testModelAcceptsNumericCombinations
{
    XCTAssertNotNil([model addAttempt:@"1234"],@"Valid attempts should be accepted");
}

- (void)testModelDoesNotAccepCombinationsLongerThanFour
{
    // Generate length between 5 and 100
    int rndlength = 5 + arc4random() % (100 - 5);
    NSString *newCombination = [self randomStringWithLength:rndlength];

    XCTAssertNil([model addAttempt:newCombination], @"A combination should contain not more than 4 digits");
    
    
}

- (void)testModelDoesNotAccepCombinationsShorterThanFour
{
    // Generate length between 5 and 100
    int rndlength = 1 + arc4random() % (3 - 1);
    NSString *newCombination = [self randomStringWithLength:rndlength];
    
    XCTAssertNil([model addAttempt:newCombination], @"A combination should contain not less than 4 digits");
    
    
}

#pragma mark - The combinations can contain duplicated numbers.

// No test needs to be done as this is not a restriction

#pragma mark - The numbers accepted in the combinations are between 1 and 4.

- (void)testModelDoesNotAccepNon1234Combinations
{
    // Generate random String
    NSString *newCombination = [self randomStringWithLength:4];
    NSCharacterSet* non1234 = [[NSCharacterSet characterSetWithCharactersInString:@"1234"] invertedSet];
    NSRange r = [newCombination rangeOfCharacterFromSet: non1234];

    while (r.location == NSNotFound) {
        newCombination = [self randomStringWithLength:4];
        r = [newCombination rangeOfCharacterFromSet: non1234];
    }
    
    // Up to this point we have a combination with at least one letter
    XCTAssertNil([model addAttempt:newCombination], @"A combination with letters should fail");

}

#pragma mark - Every time a new combination is inserted a new result will be generated.

- (void)testModelDoesAccep1234Combinations
{
    XCTAssertNotNil([model addAttempt:[self generateValidCombination]], @"A combination with 123 should be accepted");
    
}

#pragma mark - The result of a new combination inserted is a one letter “A” for each number that is in the secret combination in the right position and a letter “B” for each number that is in the combination but is not in the right position.

- (void)testModelCombinationWithACharacterAtTheRightPossitionReturnsA
{
    model.combination = @"1222";

    XCTAssertEqualObjects([model addAttempt:@"1111"], @"A", @"First possition right should return A");

    model.combination = @"2122";
    
    XCTAssertEqualObjects([model addAttempt:@"1111"], @"A", @"Second possition right should return A");

    model.combination = @"2212";
    
    XCTAssertEqualObjects([model addAttempt:@"1111"], @"A", @"Third possition right should return A");

    model.combination = @"2221";
    
    XCTAssertEqualObjects([model addAttempt:@"1111"], @"A", @"Fourth possition right should return A");
}

- (void)testModelCombinationWithTwoCharactersAtTheRightPossitionReturnsAA
{
    model.combination = @"1122";
    
    XCTAssertEqualObjects([model addAttempt:@"1111"], @"AA", @"First possitions right should return AA");

    model.combination = @"2112";
    
    XCTAssertEqualObjects([model addAttempt:@"1111"], @"AA", @"Second possitions right should return AA");
    
    model.combination = @"2211";
    
    XCTAssertEqualObjects([model addAttempt:@"1111"], @"AA", @"Thirds possitions right should return AA");
    
}

- (void)testModelCombinationWithThreeCharactersAtTheRightPossitionReturnsAAA
{
    model.combination = @"1112";
    
    XCTAssertEqualObjects([model addAttempt:@"1111"], @"AAA", @"First possition right should return AAA");
    
    model.combination = @"2111";
    
    XCTAssertEqualObjects([model addAttempt:@"1111"], @"AAA", @"First possition right should return AAA");
    
}

- (void)testModelCombinationWithTheRightCombinationReturnsAAAA
{
    model.combination = @"1111";
    
    XCTAssertEqualObjects([model addAttempt:@"1111"], @"AAAA", @"Right combination should return AAAA");
    
}

- (void)testModelCombinationWithACharacterAtTheWrongPossitionReturnsB
{
    model.combination = @"1222";
    
    XCTAssertEqualObjects([model addAttempt:@"3133"], @"B", @"Second possition right should return B");
    
    model.combination = @"2122";
    
    XCTAssertEqualObjects([model addAttempt:@"3313"], @"B", @"Third possition right should return B");
    
    model.combination = @"2212";
    
    XCTAssertEqualObjects([model addAttempt:@"3331"], @"B", @"Fourth possition right should return B");

    model.combination = @"2221";
    
    XCTAssertEqualObjects([model addAttempt:@"3313"], @"B", @"Fourth possition right should return B");

}

- (void)testModelCombinationWithtwoCharacterAtTheWrongPossitionReturnsBB
{
    model.combination = @"1122";
    
    XCTAssertEqualObjects([model addAttempt:@"3311"], @"BB", @"First possitions right should return BB");
    
    model.combination = @"2112";
    
    XCTAssertEqualObjects([model addAttempt:@"1331"], @"BB", @"Second possitions right should return BB");
    
    model.combination = @"1212";
    
    XCTAssertEqualObjects([model addAttempt:@"3131"], @"BB", @"Alternate possition right should return BB");
    
}

- (void)testModelCombinationWithThreeCharacterAtTheWrongPossitionReturnsBBB
{
    model.combination = @"1234";
    
    XCTAssertEqualObjects([model addAttempt:@"4322"], @"BBB", @"Combination should return BBB");
    
    XCTAssertEqualObjects([model addAttempt:@"2142"], @"BBB", @"Combination should return BBB");
    
    XCTAssertEqualObjects([model addAttempt:@"4121"], @"BBB", @"Combination should return BBB");
    
}

- (void)testModelCombinationWithFourCharacterAtTheWrongPossitionReturnsBBB
{
    model.combination = @"1234";
    
    XCTAssertEqualObjects([model addAttempt:@"4321"], @"BBBB", @"Combination should return BBBB");
    
    XCTAssertEqualObjects([model addAttempt:@"3421"], @"BBBB", @"Combination should return BBBB");
    
    XCTAssertEqualObjects([model addAttempt:@"2341"], @"BBBB", @"Combination should return BBBB");
    
}

- (void)testModelCombinationWithTwoCharacterAtTheWrongPossitionAndTwoAtTheRightReturnsAABB
{
    model.combination = @"1234";
    
    XCTAssertEqualObjects([model addAttempt:@"1243"], @"AABB", @"Combination should return AABB");
    
    XCTAssertEqualObjects([model addAttempt:@"2134"], @"AABB", @"Combination should return AABB");
    
    XCTAssertEqualObjects([model addAttempt:@"4231"], @"AABB", @"Combination should return AABB");
    
}

- (void)testModelCombinationWithThreeCharacterAtTheWrongPossitionAndOneAtTheRightReturnsAABB
{
    model.combination = @"1234";
    
    XCTAssertEqualObjects([model addAttempt:@"1423"], @"ABBB", @"Combination should return AABB");
    
    XCTAssertEqualObjects([model addAttempt:@"3241"], @"ABBB", @"Combination should return AABB");
    
    XCTAssertEqualObjects([model addAttempt:@"2431"], @"ABBB", @"Combination should return AABB");
    
}

#pragma mark - If the result is “AAAA” no new combination will be accepted.

- (void)testModelDoesNotAcceptAnyAttempAfterACombinationReturnsAAAA
{
    model.combination = @"1234";
    [model addAttempt:@"1234"];
    
    XCTAssertNil([model addAttempt:[self generateValidCombination]], @"A combination with 123 should be accepted");

}

#pragma mark - If the number of attempts is nine and the last result is not “AAAA” no new combination will be accepted.

// This can be infered from previous tests

#pragma mark - Its has to be possible to obtain the history of the game being played at any moment, providing the ordered sequence of pairs combination-result.

- (void)testModelMaintainsAHistoryOfAttemps
{
    XCTAssertNotNil(model.history, @"The model should offer the attempts history");
}

- (void)testModelHistoryNumberOfElementsIsEqualNumberOfAttempts
{
    // Generate a random number of attempts
    int nAttempts = 1 + arc4random() % (9 - 1);
    NSString *testCombination;
    
    for (int n=0; n<nAttempts; n++) {
        testCombination = [self generateNonWinnerCombination];
        
        [model addAttempt:testCombination];
    }

    XCTAssertEqual(model.attempts, model.history.count, @"History should have one item per attempt");
}

- (void)testModelHistoryContainsCombinationResultForEachAttempt
{
    NSString *combination1 = [self generateNonWinnerCombination];
    NSString *result1 = [model addAttempt:combination1];
    NSDictionary *expected1 = @{@"Combination" : combination1, @"Result" : result1};

    NSString *combination2 = [self generateNonWinnerCombination];
    NSString *result2 = [model addAttempt:combination2];
    NSDictionary *expected2 = @{@"Combination" : combination2, @"Result" : result2};

    
    XCTAssertEqualObjects([model.history objectAtIndex:0], expected1 , @"History should have a valid pair combination-result at first possition");
    XCTAssertEqualObjects([model.history objectAtIndex:1], expected2 , @"History should have a valid pair combination-result at first possition");
}

@end
