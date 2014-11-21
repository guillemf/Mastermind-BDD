//
//  MMProtocols.h
//  MasterMind
//
//  Created by Guillem Fernández González on 13/02/15.
//  Copyright (c) 2015 Guillem Fern√°ndez Gonz√°lez. All rights reserved.
//

#ifndef MasterMind_MMProtocols_h
#define MasterMind_MMProtocols_h

@class MMCombinationRow;

@protocol CombinationCellDelegate <NSObject>

- (void)checkCombinationFor:(MMCombinationRow *)row;
- (BOOL)isRowActive:(MMCombinationRow *)row;

@end

#endif
