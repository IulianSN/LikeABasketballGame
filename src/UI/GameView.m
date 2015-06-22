//
//  GameView.m
//  28_01_TheGame
//
//  Created by Iulian Nikolaiev on 02.02.15.
//  Copyright (c) 2015 Iulian Nikolaiev. All rights reserved.
//

#import "GameView.h"
#import "BallPosition.h"

@interface GameView ()
@property (nonatomic, weak) UIButton *activedButton;
@end

@implementation GameView

- (void)awakeFromNib {
    self.topLeftButton.alpha = 0.1f;
    self.downLeftButton.alpha = 0.1f;
    self.topRightButton.alpha = 0.1f;
    self.downRightButton.alpha = 0.1f;
    self.centerButton.alpha = 0.1f;
}

#pragma mark -
#pragma mark Accessors

- (void)setActivedButton:(UIButton *)activedButton {
    if (_activedButton != activedButton) {
        _activedButton.alpha = 0.1f;
        _activedButton = activedButton;
        _activedButton.alpha = 1.f;
    }
}

#pragma mark -
#pragma mark Public Methods

- (void)changePositionByState:(BallPosition)state animated:(BOOL)animated {
    CGRect ballViewFrame = self.ballView.frame;
    
    CGFloat ballViewWight = CGRectGetWidth(ballViewFrame);
    CGFloat ballViewHeight = CGRectGetHeight(ballViewFrame);
    CGFloat buttonWight = CGRectGetWidth(self.downLeftButton.frame);
    CGFloat buttonHeight = CGRectGetHeight(self.downLeftButton.frame);
    CGFloat viewShiftX = (buttonWight - ballViewWight)/2;
    CGFloat viewShiftY = (buttonHeight - ballViewHeight)/2;
    
    CGFloat downLeftY = CGRectGetMinY(self.downLeftButton.frame);
    CGFloat downRightY = CGRectGetMinY(self.downRightButton.frame);
    CGFloat topRightX = CGRectGetMinX(self.topRightButton.frame);
    CGFloat centerY = CGRectGetMinY(self.centerButton.frame);
    CGFloat centerX = CGRectGetMinX(self.centerButton.frame);
    
    CGFloat ballViewOriginY = 20.f;
    CGFloat ballViewOriginX = 20.f;
    
    if (BallPositionDownLeft == state) {
        ballViewOriginY = downLeftY + viewShiftY;
    } else if (BallPositionDownRight == state) {
        ballViewOriginY = downRightY + viewShiftY;
        ballViewOriginX = topRightX + viewShiftX;
    } else if (BallPositionTopRight == state) {
        ballViewOriginX = topRightX + viewShiftX;
    } else if (BallPositionCentre == state) {
        ballViewOriginY = centerY + viewShiftY;
        ballViewOriginX = centerX + viewShiftX;
    } else if (BallPositionFree == state) {
        ballViewOriginY = buttonHeight + 3*viewShiftY;
        ballViewOriginX = buttonWight + 15*viewShiftX;
    }
    self.ballLeftConstraint.constant = ballViewOriginX;
    self.ballTopConstraint.constant = ballViewOriginY;
    [UIView animateWithDuration:(animated) ? 0.1f : 0.f
                     animations:^{
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:(animated) ? 0.2f : 0.f
                                          animations:^{
                                              self.ballView.transform = CGAffineTransformMakeScale(0.4f, 0.4f);
                                          }
                                          completion:^(BOOL finished) {
                                              self.ballView.transform = CGAffineTransformMakeScale(1.f, 1.f);
                                              self.completionHandler(state);
                                          }];
                     }];
}

- (void)activateButtonByState:(BallPosition)state {
    UIButton *button = nil;
    
    switch (state) {
        case BallPositionTopLeft:
            button = self.topLeftButton;
            break;
            
        case BallPositionTopRight:
            button = self.topRightButton;
            break;
            
        case BallPositionDownRight:
            button = self.downRightButton;
            break;
            
        case BallPositionDownLeft:
            button = self.downLeftButton;
            break;
            
        case BallPositionCentre:
            button = self.centerButton;
            break;
            
        default:
            break;
    }
    self.activedButton = button;
}

- (void)enableButtons:(BOOL)enable {
    self.topLeftButton.userInteractionEnabled = enable;
    self.topRightButton.userInteractionEnabled = enable;
    self.centerButton.userInteractionEnabled = enable;
    self.downLeftButton.userInteractionEnabled = enable;
    self.downRightButton.userInteractionEnabled = enable;
}

- (void)refreshAllLabels {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger bestScore = [userDefaults integerForKey:@"bestScore"];
    
    self.timeLeftLabel.text = @"30 sec left";
    self.totalScoreLabel.text = @"Score 0";
    self.addedPointLabel.text = @"0 points";
    self.bestScoreLabel.text = [NSString stringWithFormat:@"Best score %lu", bestScore];
}

@end
