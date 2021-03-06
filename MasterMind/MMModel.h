//
//  MMModel.h
//  MasterMind
//
//  Created by Guillem Fernández González on 30/09/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMModel : NSObject

@property (nonatomic, strong) NSString *combination;
@property (nonatomic, readonly) NSUInteger attempts;
@property (nonatomic, strong) NSArray *history;

- (void)start;
- (NSString *)addAttempt:(NSString *)combination;

@end
