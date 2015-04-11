//
//  PlayingCardView.h
//  Assignment 4
//
//  Created by Alex Smith on 11/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
