//
//  NSArray+Test.m
//  MasterMind
//
//  Created by Guillem Fernández González on 24/02/15.
//  Copyright (c) 2015 Guillem Fern√°ndez Gonz√°lez. All rights reserved.
//

#import "NSArray+Test.h"

@implementation NSArray(Test)

+ (NSArray *)generateRandomListOfRows
{
    int totalRows = arc4random_uniform(4);
    
    while (totalRows == 0) totalRows = arc4random_uniform(4);
    
    NSMutableArray *listRows = [NSMutableArray array];
    
    for (int n= 0; n<totalRows; n++) {
        int newBlankRow = newBlankRow = arc4random_uniform(4);
        while ([listRows containsObject:[NSNumber numberWithInt:newBlankRow]])
        {
            newBlankRow = arc4random_uniform(4);
        }
        [listRows addObject:[NSNumber numberWithInt:newBlankRow]];
    }
    
    return [listRows copy];
}

@end
