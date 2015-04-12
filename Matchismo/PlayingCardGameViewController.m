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

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberCardMatchingMode = 2;
    self.numberOfCards = 12;
}

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(UIView *)cardViewForCard:(Card *)card toDisplayInRect:(CGRect)rect
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

@end
