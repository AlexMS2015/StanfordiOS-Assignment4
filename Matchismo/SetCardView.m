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
    return @[[UIColor greenColor], [UIColor redColor], [[UIColor purpleColor]][index];
}

-(void)drawRect:(CGRect)rect
{
    for (int numSymbols = 0; numSymbols <[self.number integerValue]; numSymbols++) {
        
        UIBezierPath *symbolToDraw = [[UIBezierPath alloc] init];
        
        if ([self.symbol integerValue] == 0) {
            symbolToDraw = [self triangle];
        } else if ([self.symbol integerValue] == 1) {
            symbolToDraw = [self oval];
        } else if ([self.symbol integerValue] == 2) {
            symbolToDraw = [self squiggle];
        }
    }
}

-(UIBezierPath *)triangle
{
    return nil;
}

-(UIBezierPath *)oval
{
    return nil;
}

-(UIBezierPath *)squiggle
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
