//
//  NSString+Test.m
//  MasterMind
//
//  Created by Guillem Fernández González on 23/02/15.
//  Copyright (c) 2015 Guillem Fern√°ndez Gonz√°lez. All rights reserved.
//

#import "NSString+Test.h"

@implementation NSString(test)

NSString *NSTletters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
NSString *NSTvalidValues = @"1234";
int NSTcombinationLength = 4;

+ (NSString *)randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [NSTletters characterAtIndex: arc4random_uniform((int)[NSTletters length]) % [NSTletters length]]];
    }
    
    return randomString;
}

+ (NSString *)generateValidCombination {
    
    NSMutableString *randomSCombination = [NSMutableString stringWithCapacity: NSTcombinationLength];
    
    for (int i=0; i<NSTcombinationLength; i++) {
        [randomSCombination appendFormat: @"%C", [NSTvalidValues characterAtIndex: arc4random_uniform((int)[NSTvalidValues length]) % [NSTvalidValues length]]];
    }
    
    return randomSCombination;
    
}

+ (NSString *)generateValidResult
{
    int resultLength = arc4random_uniform(NSTcombinationLength);
    NSMutableString *result = [NSMutableString stringWithCapacity:NSTcombinationLength];
    
    for (int n=0; n<resultLength; n++) {
        [result appendString:@"A"];
    }
    
    for (int m=resultLength; m<4; m++) {
        [result appendString:@"B"];
    }
    
    return [result copy];
}

@end
