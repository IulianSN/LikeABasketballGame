//
//  GameView.h
//  28_01_TheGame
//
//  Created by Iulian Nikolaiev on 02.02.15.
//  Copyright (c) 2015 Iulian Nikolaiev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BallPosition.h"

typedef void(^GameViewAnimationCompletionHandler)(BallPosition state);

@interface GameView : UIView

@property (nonatomic, weak) IBOutlet UILabel   *timeLeftLabel;
@property (nonatomic, weak) IBOutlet UILabel   *totalScoreLabel;
@property (nonatomic, weak) IBOutlet UILabel   *addedPointLabel;
@property (nonatomic, weak) IBOutlet UILabel   *bestScoreLabel;
@property (nonatomic, weak) IBOutlet UIView    *ballView;
@property (nonatomic, weak) IBOutlet UIButton  *topLeftButton;
@property (nonatomic, weak) IBOutlet UIButton  *downLeftButton;
@property (nonatomic, weak) IBOutlet UIButton  *topRightButton;
@property (nonatomic, weak) IBOutlet UIButton  *downRightButton;
@property (nonatomic, weak) IBOutlet UIButton  *centerButton;
@property (nonatomic, weak) IBOutlet UIButton  *startStopButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *ballLeftConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *ballTopConstraint;
@property (nonatomic, copy) GameViewAnimationCompletionHandler completionHandler;

- (void)changePositionByState:(BallPosition)state animated:(BOOL)animated;
- (void)activateButtonByState:(BallPosition)state;
- (void)enableButtons:(BOOL)enable;
- (void)refreshAllLabels;

@end
