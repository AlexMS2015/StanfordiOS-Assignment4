//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Alex Smith on 6/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"
#import "Grid.h"

@implementation PlayingCardGameViewController

-(void)awakeFromNib
{    
    self.numberCardMatchingMode = 2;
    self.numberOfCardsInitial = 24;
    self.removeMatchCardsFromInterface = NO;
}

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(UIView *)viewForCard:(Card *)card toDisplayInRect:(CGRect)rect
{
    if ([card isMemberOfClass:[PlayingCard class]]) {
        PlayingCard *playingCard = (PlayingCard *)card;
        PlayingCardView *cardToDisplay = [[PlayingCardView alloc] initWithFrame:rect];
        
        cardToDisplay.rank = playingCard.rank;
        cardToDisplay.suit = playingCard.suit;
        cardToDisplay.faceUp = playingCard.isChosen;
        
        return cardToDisplay;
    } else {
        return nil;
    }
}

-(void)updateCardView:(UIView *)cardView withCard:(Card *)card
{
    if (!card.isMatched) {
        if ([cardView isMemberOfClass:[PlayingCardView class]] && [card isMemberOfClass:[PlayingCard class]]) {
            
            PlayingCard *playingCard = (PlayingCard *)card;
            PlayingCardView *playingCardViewToUpdate = (PlayingCardView *)cardView;
            
            if (playingCardViewToUpdate.faceUp != playingCard.isChosen) {
                [self flipCardView:playingCardViewToUpdate withCard:playingCard];
            } else {
                playingCardViewToUpdate.rank = playingCard.rank;
                playingCardViewToUpdate.suit = playingCard.suit;
                playingCardViewToUpdate.faceUp = playingCard.isChosen;
            }
            
        }
    }
}

-(void)flipCardView:(PlayingCardView *)playingCardViewToUpdate withCard:(PlayingCard *)playingCard;
{
    playingCardViewToUpdate.rank = playingCard.rank;
    playingCardViewToUpdate.suit = playingCard.suit;
    
    [UIView transitionWithView:playingCardViewToUpdate
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                    
                    playingCardViewToUpdate.faceUp = playingCard.isChosen;

                    }
                    completion:nil];
}

@end
