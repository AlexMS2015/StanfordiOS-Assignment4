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

-(void)drawRect:(CGRect)rect
{
    
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:2];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    //UIRectFill(self.bounds);
    [roundedRect fill];
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.faceUp) {
        [self drawShapes];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}

#define OFFSET1_PERCENTAGE 0.3 // % of view width from horizontal centre
#define OFFSET2_PERCENTAGE 0.2

-(void)drawShapes
{    
    if (self.number == 1 || self.number == 3) {
        [self drawShape:OVALSHAPE
             withOffset:0
               mirrored:NO];
    }
    
    if (self.number == 2) {
        [self drawShape:OVALSHAPE
             withOffset:OFFSET2_PERCENTAGE
               mirrored:YES];
    }
    
    if (self.number == 3) {
        [self drawShape:OVALSHAPE
             withOffset:OFFSET1_PERCENTAGE
               mirrored:YES];
    }
}

-(UIBezierPath *)drawShape:(ShapeName)shape
   withOffset:(CGFloat)offset
   mirrored:(BOOL)mirrored
{
    
    [self drawShape:shape withOffset:offset];
    
    if (mirrored) {
        [self drawShape:shape withOffset:(-offset)];
    }
    
    return nil;
}

#define SYMBOLTOVIEWRATIO_WIDTH 0.8
#define SYMBOLTOVIEWRATIO_HEIGHT 0.2

-(UIBezierPath *)drawShape:(ShapeName)symbol
       withOffset:(CGFloat)offset
{

    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2); // centre in OWN co-ordinate system
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGPoint shapeOrigin =
        CGPointMake((width * (1 - SYMBOLTOVIEWRATIO_WIDTH)) / 2 , center.y + (offset * height) - (SYMBOLTOVIEWRATIO_HEIGHT/2 * height));
    
    CGSize shapeSize = CGSizeMake(SYMBOLTOVIEWRATIO_WIDTH * width, SYMBOLTOVIEWRATIO_HEIGHT * height);
    
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
        [self addStripesToShape:shapeToDraw inRect:rectToDrawShapeIn];
    }
    
    return nil;
}

-(UIBezierPath *)diamondInRect:(CGRect)rect
{
    CGPoint left = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2);
    CGPoint top = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y);
    CGPoint right =
        CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2);
    CGPoint bottom =
        CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height);
    
    UIBezierPath *triangle = [[UIBezierPath alloc] init];
    [triangle moveToPoint:left];
    [triangle addLineToPoint:top];
    [triangle addLineToPoint:right];
    [triangle addLineToPoint:bottom];
    [triangle closePath];
    
    return triangle;
}

-(UIBezierPath *)ovalInRect:(CGRect)rect
{
    UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:rect];

    return oval;
}

-(void)displayPointInTerminal:(CGPoint)point
{
    NSLog(@"X = %f", point.x);
    NSLog(@"Y = %f", point.y);
}

-(UIBezierPath *)squiggleInRect:(CGRect)rect
{
    UIBezierPath *squiggle = [[UIBezierPath alloc] init];
    
    CGPoint firstArcStart = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
    CGPoint firstArcEnd = CGPointMake(0.25 * rect.size.width, rect.origin.y);
    CGPoint firstArcControl = rect.origin;
    [squiggle moveToPoint:firstArcStart];
    [squiggle addQuadCurveToPoint:firstArcEnd controlPoint:firstArcControl];
    
    CGPoint secondArcEnd = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
    CGPoint secondArcControl = CGPointMake(rect.origin.x + 0.75 * rect.size.width, rect.origin.y + rect.size.height);
    [squiggle addQuadCurveToPoint:secondArcEnd controlPoint:secondArcControl];
    
    /*
    [[UIColor blackColor] setStroke];
    [squiggle stroke];
    
    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(rect.size.width, 2* rect.size.height);
    [squiggle applyTransform:rotate];
    [squiggle applyTransform:translate];
    */
    
    CGPoint thirdArcEnd = secondArcControl;
    CGPoint thirdArcControl = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    [squiggle addQuadCurveToPoint:thirdArcEnd controlPoint:thirdArcControl];
    
    CGPoint fourthArcEnd = firstArcStart;
    CGPoint fourthArcControl = CGPointMake(rect.origin.x + 0.25 * rect.size.width, rect.origin.y + 0.5 * rect.size.height);
    [squiggle addQuadCurveToPoint:fourthArcEnd controlPoint:fourthArcControl];
     
    return squiggle;
}

-(void)addStripesToShape:(UIBezierPath *)shape inRect:(CGRect)rect
{
    CGFloat horizontalIncrement = rect.size.width / 25;
    CGFloat verticalIncrement = rect.size.height / 50;
    
    UIBezierPath *stripes = [[UIBezierPath alloc] init];
    
    for (CGFloat horizontalLocation = rect.origin.x; horizontalLocation < rect.origin.x + rect.size.width; horizontalLocation += horizontalIncrement) {
        
        CGPoint startPoint;
        
        for (CGFloat verticalLocation = rect.origin.y; verticalLocation < rect.origin.y + rect.size.height; verticalLocation += verticalIncrement) {
            
            CGPoint currentPoint = CGPointMake(horizontalLocation, verticalLocation);
            
            if ([shape containsPoint:currentPoint]) {
                startPoint = currentPoint;
                break;
            }
        }
        
        CGPoint endPoint;
        for (CGFloat verticalLocation = startPoint.y; verticalLocation < rect.origin.y + rect.size.height; verticalLocation += verticalIncrement) {
            
            endPoint = CGPointMake(horizontalLocation, verticalLocation);
            
            if (![shape containsPoint:endPoint]) {
                break;
            }
        }
        
        [stripes moveToPoint:startPoint];
        [stripes addLineToPoint:endPoint];
    }
    
    [[self colourFromIndex:self.colour] setStroke];
    [stripes stroke];
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
