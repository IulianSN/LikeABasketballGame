//
//  GameViewController.m
//  28_01_TheGame
//
//  Created by Iulian Nikolaiev on 02.02.15.
//  Copyright (c) 2015 Iulian Nikolaiev. All rights reserved.
//

#import "GameViewController.h"
#import "GameView.h"
#import "StatesModel.h"

@interface GameViewController ()
@property (nonatomic, strong)   NSTimer     *timer;
@property (nonatomic, readonly) GameView    *firstAppView;
@property (nonatomic, assign)   NSUInteger  time;
@property (nonatomic, assign)   NSUInteger  totalScore;
@property (nonatomic, assign)   BOOL        tuned;
@property (nonatomic, assign)   BOOL        started;
@end

@implementation GameViewController

@dynamic firstAppView;

#pragma mark -
#pragma mark View's Lifecircle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.model reloadStates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (NO == self.tuned) {
        StatesModel *model = self.model;
        __weak GameViewController *selfWeak = self;
        
        self.firstAppView.completionHandler = ^(BallPosition state){
            if (BallPositionFree != state) {
                [model generateNewState];
                [selfWeak.firstAppView activateButtonByState:model.currentState];
                [selfWeak.firstAppView enableButtons:YES];
            }
        };
        [self refresh];
        self.tuned = YES;
    }
}

#pragma mark -
#pragma makr Accessors

- (GameView *)firstAppView {
    return (GameView *)self.view;
}

- (void)setTimer:(NSTimer *)timer {
    if (_timer != timer) {
        [_timer invalidate];
        _timer = timer;
    }
}

#pragma mark -
#pragma mark Interface Handlers

- (void)handleActionForState:(BallPosition)state {
    BOOL increaseScore = YES;
    
    if (state == self.model.currentState) {
        GameView *gameView = self.firstAppView;
        
        [gameView changePositionByState:state
                               animated:YES];
        [gameView enableButtons:NO];
    } else {
        increaseScore = NO;
    }
    [self increaseScore:increaseScore];
}

- (IBAction)onTopLeft:(id)sender {
    [self handleActionForState:BallPositionTopLeft];
}

- (IBAction)onTopRight:(id)sender {
    [self handleActionForState:BallPositionTopRight];
}

- (IBAction)onDownRight:(id)sender {
    [self handleActionForState:BallPositionDownRight];
}

- (IBAction)onDownLeft:(id)sender {
    [self handleActionForState:BallPositionDownLeft];
}

- (IBAction)onCenter:(id)sender {
    [self handleActionForState:BallPositionCentre];
}

- (IBAction)onStartStop:(id)sender {
    BOOL started = self.started;
    StatesModel *model = self.model;
    GameView *gameView = self.firstAppView;
    
    if (started) {
        [self refresh];
    } else {
        [model generateNewState];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                      target:self
                                                    selector:@selector(timerFired:)
                                                    userInfo:nil
                                                     repeats:YES];
        [gameView enableButtons:YES];
        [gameView.startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    }
    [gameView activateButtonByState:model.currentState];
    self.started = !started;
}

#pragma mark -
#pragma mark Private Methods

- (void)refresh {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger bestScore = [userDefaults integerForKey:@"bestScore"];
    
    if (self.totalScore > bestScore) {
        [userDefaults setInteger:self.totalScore forKey:@"bestScore"];
        [userDefaults synchronize];
        [[[UIAlertView alloc] initWithTitle:@"Congratulations"
                                    message:[NSString stringWithFormat:@"Your score %lu is the best on this device", (unsigned long)self.totalScore]
                                   delegate:nil
                          cancelButtonTitle:@"Ok"
                          otherButtonTitles:nil] show];
    }
    
    GameView *gameView = self.firstAppView;
    
    [self.model reloadStates];
    [gameView enableButtons:NO];
    [gameView refreshAllLabels];
    [gameView changePositionByState:self.model.currentState animated:NO];
    [gameView.startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    self.timer = nil;
    self.totalScore = 0;
    self.time = 30;
}

- (void)timerFired:(NSTimer *)timer {
    self.time --;
    NSUInteger time = self.time;
    GameView *gameView = self.firstAppView;
    
    gameView.timeLeftLabel.text = [NSString stringWithFormat:@"%ld sec left", (long)time];
    if (0 == time) {
        [self refresh];
        [gameView activateButtonByState:self.model.currentState];
        self.started = NO;
    }
}

- (void)increaseScore:(BOOL)score {
    NSInteger value = 1;
    
    if (!score) {
        value = -1;
    }
    self.totalScore += value;
    self.firstAppView.totalScoreLabel.text = [NSString stringWithFormat:@"Score %ld", self.totalScore];
    self.firstAppView.addedPointLabel.text = [NSString stringWithFormat:@"%ld point", value];
}

@end
