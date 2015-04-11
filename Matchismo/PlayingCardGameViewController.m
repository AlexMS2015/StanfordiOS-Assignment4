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

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

-(Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    //return (card ? [[NSAttributedString alloc] initWithString:card.contents attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}] : [[NSMutableAttributedString alloc] init]);
    
    return [[NSAttributedString alloc] initWithString:card.contents attributes:@{ NSForegroundColorAttributeName : [UIColor blackColor]}];
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed: (card.isChosen ? @"cardfront" : @"cardback")];
}

@end
