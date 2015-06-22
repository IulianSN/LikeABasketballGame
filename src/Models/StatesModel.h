//
//  StatesModel.h
//  28_01_TheGame
//
//  Created by Iulian Nikolaiev on 02.02.15.
//  Copyright (c) 2015 Iulian Nikolaiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BallPosition.h"

@interface StatesModel : NSObject

@property (nonatomic, readonly) BallPosition currentState;

- (void)reloadStates;
- (BallPosition)generateNewState;

@end
