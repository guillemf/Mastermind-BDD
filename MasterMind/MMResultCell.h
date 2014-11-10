//
//  MMResultCell.h
//  MasterMind
//
//  Created by Guillem Fernández González on 22/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMResultCell : UIView

@property (strong, nonatomic) NSString *result;
@property (strong, readonly ) NSArray  *bezierPaths;
@property (strong, nonatomic) UIColor  *color;

@end
