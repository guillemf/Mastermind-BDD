//
//  MMCell.h
//  MasterMind
//
//  Created by Guillem Fernández González on 20/10/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMCell : UIView

@property (nonatomic, readonly) UIBezierPath *bezierPath;
@property (nonatomic, strong) UIColor *color;

@end
