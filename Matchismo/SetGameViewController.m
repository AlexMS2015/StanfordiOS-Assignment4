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
    self.numberOfCardsInitial = 12;
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
        
        [self setAttributesOfCardView:cardToDisplay withCard:setCard];

        return cardToDisplay;
    } else {
        return nil;
    }
}

-(void)updateCardView:(UIView *)cardView withCard:(Card *)card toDisplayInRect:(CGRect)rectToDisplayCardIn
{
    if ([cardView isMemberOfClass:[SetCardView class]] && [card isMemberOfClass:[SetCard class]]) {
        SetCardView *setCardView = (SetCardView *)cardView;
        SetCard *setCard = (SetCard *)card;
        
        [self setAttributesOfCardView:setCardView withCard:setCard];
        setCardView.frame = rectToDisplayCardIn;
    }
}

-(void)setAttributesOfCardView:(SetCardView *)setCardview withCard:(SetCard *)setCard
{
    setCardview.number = setCard.number;
    setCardview.colour = setCard.colour;
    
    if (setCard.symbol == 1) {
        setCardview.shape = DIAMONDSHAPE;
    } else if (setCard.symbol == 2) {
        setCardview.shape = OVALSHAPE;
    } else {
        setCardview.shape = SQUIGGLESHAPE;
    }
    
    if (setCard.shading == 0) {
        setCardview.shading = NONE;
    } else if (setCard.shading == 1) {
        setCardview.shading = STRIPED;
    } else {
        setCardview.shading = FILLED;
    }
    
    setCardview.chosen = setCard.isChosen;
}
@end
