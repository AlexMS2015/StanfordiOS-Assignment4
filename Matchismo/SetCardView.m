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

#define HOFFSET1_PERCENTAGE 0.33
#define HOFFSET2_PERCENTAGE 0.66

-(void)drawRect:(CGRect)rect
{

    if ([self.number integerValue] == 1 || [self.number integerValue] == 3) {
        
        [self drawSymbol:[self.symbol integerValue]
    WithHorizontalOffset:0
    mirroredHorizontally:NO];
        
    } else if ([self.number integerValue] == 2) {
        
        [self drawSymbol:[self.symbol integerValue]
    WithHorizontalOffset:HOFFSET1_PERCENTAGE
    mirroredHorizontally:YES];
        
    } else if ([self.number integerValue] == 2) {
        
        [self drawSymbol:[self.symbol integerValue]
    WithHorizontalOffset:HOFFSET2_PERCENTAGE
    mirroredHorizontally:YES];
        
    }
}

-(void)addStripes
{
    
}

-(UIBezierPath *)drawSymbol:(NSInteger)symbol
   WithHorizontalOffset:(CGFloat)hoffset
   mirroredHorizontally:(BOOL)mirroredHorizontally
{

    // call other drawsymbol method
    // call other drawsymbol method with flipped set to YES if appropriate
    
    return nil;
}

-(UIBezierPath *)drawSymbol:(NSInteger)symbol
       WithHorizontalOffset:(CGFloat)hoffset
                    flipped:(BOOL)flipped
{
    // create a rectangle based on offset
    // get a bezier path for the relevant shape in that rectangle
    // draw that shape with relevant fill and stroke
    
    UIBezierPath *symbolToDraw = [[UIBezierPath alloc] init];
    
    [[self colourFromIndex:[self.colour integerValue]] setStroke];
    
    [symbolToDraw stroke];
    
    if ([self.shading integerValue] == 1) {
        [[self colourFromIndex:[self.colour integerValue]] setFill];
        [symbolToDraw fill];
    } else if ([self.shading integerValue] == 2) {
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
    return nil;
}

-(UIBezierPath *)squiggleInRect:(CGRect)rect
{
    return nil;
}


#pragma mark - Properties

-(void)setNumber:(NSNumber *)number
{
    _number = number;
    [self setNeedsDisplay];
}

-(void)setSymbol:(NSNumber *)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

-(void)setShading:(NSNumber *)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

-(void)setColour:(NSNumber *)colour
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
