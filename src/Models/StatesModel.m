//
//  StatesModel.m
//  28_01_TheGame
//
//  Created by Iulian Nikolaiev on 02.02.15.
//  Copyright (c) 2015 Iulian Nikolaiev. All rights reserved.
//

#import "StatesModel.h"

@interface StatesModel ()
@property (nonatomic, assign) BallPosition currentState;
@property (nonatomic, strong) NSMutableArray         *states;
@end

@implementation StatesModel

#pragma mark -
#pragma mark Public Methods

- (void)reloadStates {
    self.currentState = BallPositionFree;
    self.states = [@[@(BallPositionTopLeft),
                     @(BallPositionTopRight),
                     @(BallPositionDownRight),
                     @(BallPositionDownLeft),
                     @(BallPositionCentre)] mutableCopy];
}

- (BallPosition)generateNewState {
    NSMutableArray *states = self.states;
    BallPosition currentState = self.currentState;
    u_int32_t randomNumber = 4;
    
    if (BallPositionFree == currentState) {
        randomNumber = 5;
    }
    
    u_int32_t index = arc4random_uniform(randomNumber);
    
    NSNumber *newStateNumber = [states objectAtIndex:index];
    BallPosition newState = [newStateNumber unsignedIntegerValue];
    
    [states removeObject:newStateNumber];
    if (BallPositionFree != currentState) {
        [states addObject:@(currentState)];
    }
    self.currentState = newState;
    
    return newState;
}

@end
