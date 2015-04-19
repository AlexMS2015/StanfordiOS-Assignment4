//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Alex Smith on 6/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@implementation SetGameViewController

-(void)awakeFromNib
{    
    self.numberCardMatchingMode = 3;
    self.numberOfCards = 12;
}

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(UIView *)viewForCard:(Card *)card toDisplayInRect:(CGRect)rect
{
    if ([card isMemberOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        
        SetCardView *cardToDisplay = [[SetCardView alloc] initWithFrame:rect];
        cardToDisplay.number = setCard.number;
        cardToDisplay.colour = setCard.colour;
        
        if (setCard.symbol == 1) {
            cardToDisplay.shape = DIAMONDSHAPE;
        } else if (setCard.symbol == 2) {
            cardToDisplay.shape = OVALSHAPE;
        } else {
            cardToDisplay.shape = SQUIGGLESHAPE;
        }
        
        if (setCard.shading == 0) {
            cardToDisplay.shading = NONE;
        } else if (setCard.shading == 1) {
            cardToDisplay.shading = STRIPED;
        } else {
            cardToDisplay.shading = FILLED;
        }
        
        cardToDisplay.faceUp = setCard.isChosen;
        
        return cardToDisplay;
    } else {
        return nil;
    }
}

@end
