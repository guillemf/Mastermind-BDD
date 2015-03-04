//
//  MMViewController.h
//  MasterMind
//
//  Created by Guillem Fernández González on 30/09/14.
//  Copyright (c) 2014 Guillem Fernández González. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMProtocols.h"

@interface MMViewController : UIViewController<CombinationCellDelegate>

- (NSString *)currentCombination;

@end
