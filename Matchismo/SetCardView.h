//
//  SetCardView.h
//  Assignment 4
//
//  Created by Alex Smith on 12/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShapeName) {
    DIAMONDSHAPE = 1,
    OVALSHAPE = 2,
    SQUIGGLESHAPE = 3
};

typedef NS_ENUM(NSUInteger, ShapeShading) {
    NONE = 1,
    STRIPED = 2,
    FILLED = 3
};

@interface SetCardView : UIView

@property (nonatomic) NSUInteger number;
@property (nonatomic) ShapeName shape;
@property (nonatomic) ShapeShading shading;
@property (nonatomic) NSUInteger colour;
@property (nonatomic) BOOL faceUp;

@end
