//
//  MMModel.m
//  MasterMind
//
//  Created by Guillem Fernández González on 30/09/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import "MMModel.h"

@interface MMModel()

@property (nonatomic, strong) NSString *lastResult;

@end


@implementation MMModel


- (id)init{
    
    self = [super init];
    
    if (self) {
        [self start];
    }
    
    return self;
}


- (void)start {
    
    int rndDigit;
    NSMutableString *newCombination = [NSMutableString stringWithString:@""];
    
    do {
        rndDigit = 1 + arc4random() % (4 - 1);
        [newCombination appendFormat:@"%d", rndDigit];
    } while (newCombination.length < 4);
    
    self.combination = [newCombination copy];
    self.history = @[];
    _attempts = 0;
}

- (NSString *)addAttempt:(NSString *)combination
{
    // Test length
    if (combination.length != 4) return nil;
    
    // Test contents
    NSCharacterSet* non1234 = [[NSCharacterSet characterSetWithCharactersInString:@"1234"] invertedSet];
    NSRange r = [combination rangeOfCharacterFromSet: non1234];

    if (r.location != NSNotFound) return nil;
 
    // Test last result was not AAAA
    if ([self.lastResult isEqualToString:@"AAAA"]) return nil;
    
    NSMutableString *result = [@"" mutableCopy];
    NSString *testCombination = [self.combination copy];
    
    if (_attempts <= 8) {
        
        // Find A's
        for (int cPos = 0; cPos<4; cPos++) {
            
            if ([self.combination characterAtIndex:cPos] == [combination characterAtIndex:cPos]) {
                [result appendString:@"A"];
                testCombination = [testCombination stringByReplacingCharactersInRange:NSMakeRange(cPos, 1)
                                                                           withString:@"X"];
            }
        }
        
        // Find B's
        for (int cPos = 0; cPos<4; cPos++) {
            r = [testCombination rangeOfString:[combination substringWithRange:NSMakeRange(cPos, 1)]];
            if (r.location != NSNotFound) {
                [result appendString:@"B"];
                testCombination = [testCombination stringByReplacingCharactersInRange:NSMakeRange(r.location, 1)
                                                                           withString:@"X"];
            }
        }

        // Save results
        _attempts++;
        self.lastResult = result;
        self.history = [self.history arrayByAddingObject:@{@"Combination" : combination, @"Result" : result}];
        return [result copy];
    }
    
    return nil;
}

@end
