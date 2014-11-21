//
//  NSString+Test.h
//  MasterMind
//
//  Created by Guillem Fernández González on 23/02/15.
//  Copyright (c) 2015 Guillem Fern√°ndez Gonz√°lez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(test)

+ (NSString *)randomStringWithLength: (int) len;
+ (NSString *)generateValidCombination;
+ (NSString *)generateValidResult;

@end
