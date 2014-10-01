//
//  MMModel.m
//  MasterMind
//
//  Created by Guillem Fernández González on 30/09/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import "MMModel.h"

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
}

@end
