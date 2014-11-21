//
//  MMCombinationRow.h
//  MasterMind
//
//  Created by Guillem Fernández González on 11/11/14.
//  Copyright (c) 2014 Guillem Fern√°ndez Gonz√°lez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMProtocols.h"

@interface MMCombinationRow : UIView

@property (nonatomic, weak) id<CombinationCellDelegate> delegate;
@property (nonatomic) NSString *combination;

- (void)setResult:(NSString *)result;

@end
