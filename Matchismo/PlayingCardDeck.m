//
//  PlayingCardDeck.m
//  Matchismo
//
//  Created by Alex Smith on 25/10/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import "PlayingCardDeck.h"
#import "PlayingCard.h"

@implementation PlayingCardDeck

-(instancetype)init // instacetype says to return an object of the same type of the object that the 'init' message was called on (this proofs the method for subclassing).
{
    self = [super init]; // 'super' sends a message to OURSELVES but uses the superclass's version of the method instead on OURSELVES ??
    
    if (self) { // check that the super class could initialise, don't continue if not
        for (NSString *suit in [PlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank < [PlayingCard maxRank]; rank++) { // start at 1 as rank 0 is reserved for when the rank is not set
                PlayingCard *card = [[PlayingCard alloc] init]; // must always call init after alloc
                card.rank = rank;
                card.suit = suit;
                [self addCard:card]; // sends the addCard message from the superclass (deck) to current instance of PlayingCardDeck
            }
        }
    }
    
    return self;
}

@end
