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
    
    int randomNumber = arc4random() % 9000 + 1000;
    self.combination = [NSString stringWithFormat:@"%d", randomNumber];
}

@end
