//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Alex Smith on 27/10/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

// Designated initialised (should always comments this if it is different from the parent class's. must always call the parent's initialiser from our designated initialiser. any other initialisers we have will call the designated one)
-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck
               usingMatchModeNum:(NSUInteger)matchModeNum;
-(void)chooseCardAtIndex:(NSUInteger)index;
-(Card *)cardAtIndex:(NSUInteger)index; // because the internal array of cards is not visible we need a method that returns a card at a specific index instead.

@property (nonatomic, readonly) NSInteger score;
@property (readonly) NSInteger lastScore; // the amount the total score changed by due to the most recent card selection
@property (nonatomic, readonly, strong) NSArray *lastCardsChosenToMatch; // the group of cards (2 or 3 or more depending on the game) that were chosen in the last match attempt (i.e. in a 3 card game, this array will contain the 3 cards that were chosen previously, whether they were matched or not).
@property (nonatomic, readonly, strong) Card *lastCardChosen; // the last single card chosen

@end
