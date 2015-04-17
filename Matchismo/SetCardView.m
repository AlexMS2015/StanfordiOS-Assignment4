//
//  SetCardView.m
//  Assignment 4
//
//  Created by Alex Smith on 12/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

-(UIColor *)colourFromIndex:(NSUInteger)index
{
    return @[[UIColor greenColor], [UIColor redColor], [UIColor purpleColor]][index];
}

#define HOFFSET1_PERCENTAGE 0.3 // % of view width from horizontal centre
#define HOFFSET2_PERCENTAGE 0.2

-(void)drawRect:(CGRect)rect
{

    if (self.number == 1 || self.number == 3) {
        
        [self drawShape:self.shape
    WithHorizontalOffset:0
    mirroredHorizontally:NO];
        
    }
    
    if (self.number == 2) {
        
        [self drawShape:self.shape
    WithHorizontalOffset:HOFFSET1_PERCENTAGE
    mirroredHorizontally:YES];
        
    }
        
    if (self.number == 3) {
        
        [self drawShape:self.shape
    WithHorizontalOffset:HOFFSET2_PERCENTAGE
    mirroredHorizontally:YES];
        
    }
}

-(UIBezierPath *)drawShape:(ShapeName)shape
   WithHorizontalOffset:(CGFloat)hoffset
   mirroredHorizontally:(BOOL)mirroredHorizontally
{
    
    [self drawShape:shape WithHorizontalOffset:hoffset flipped:NO];
    
    if (mirroredHorizontally) {
        [self drawShape:shape WithHorizontalOffset:(-hoffset) flipped:YES];
    }
    
    return nil;
}

#define SYMBOLTOVIEWRATIO_WIDTH 0.8
#define SYMBOLTOVIEWRATIO_HEIGHT 0.8

-(UIBezierPath *)drawShape:(ShapeName)symbol
       WithHorizontalOffset:(CGFloat)hoffset
                    flipped:(BOOL)flipped
{

    CGPoint center = self.center;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGPoint shapeOrigin =
        CGPointMake(center.x + hoffset * width , (height - SYMBOLTOVIEWRATIO_HEIGHT) / 2);
    CGSize shapeSize = CGSizeMake(SYMBOLTOVIEWRATIO_WIDTH * self.bounds.size.width, SYMBOLTOVIEWRATIO_HEIGHT * self.bounds.size.height);
    
    CGRect rectToDrawShapeIn =
        CGRectMake(shapeOrigin.x, shapeOrigin.y, shapeSize.width, shapeSize.height);
    
    UIBezierPath *shapeToDraw = [[UIBezierPath alloc] init];
    
    if (self.shape == DIAMONDSHAPE) {
        shapeToDraw = [self diamondInRect:rectToDrawShapeIn];
    } else if (self.shape == OVALSHAPE) {
        shapeToDraw = [self ovalInRect:rectToDrawShapeIn];
    } else if (self.shape == SQUIGGLESHAPE) {
        shapeToDraw = [self squiggleInRect:rectToDrawShapeIn];
    }
    
    [[self colourFromIndex:self.colour] setStroke];
    
    [shapeToDraw stroke];
    
    if (self.shading == FILLED) {
        [[self colourFromIndex:self.colour] setFill];
        [shapeToDraw fill];
    } else if (self.shading == STRIPED) {
        [self addStripes];
    }
    
    return nil;
}

-(UIBezierPath *)diamondInRect:(CGRect)rect
{
    return nil;
}

-(UIBezierPath *)ovalInRect:(CGRect)rect
{
    UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:rect];
    
    return oval;
}

-(UIBezierPath *)squiggleInRect:(CGRect)rect
{
    return nil;
}

-(void)addStripes
{

}

#pragma mark - Properties

-(void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

-(void)setShape:(ShapeName)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

-(void)setShading:(ShapeShading)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

-(void)setColour:(NSUInteger)colour
{
    _colour = colour;
    [self setNeedsDisplay];
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
