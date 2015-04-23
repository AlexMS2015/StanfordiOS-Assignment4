//
//  SetCardView.h
//  Assignment 4
//
//  Created by Alex Smith on 12/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShapeName) {
    DIAMONDSHAPE = 0,
    OVALSHAPE = 1,
    SQUIGGLESHAPE = 2
};

typedef NS_ENUM(NSUInteger, ShapeShading) {
    NONE = 0,
    STRIPED = 1,
    FILLED = 2
};

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) ShapeName shape;
@property (nonatomic) ShapeShading shading;
@property (nonatomic) NSUInteger colour;
@property (nonatomic, getter = isChosen) BOOL chosen;

@end
