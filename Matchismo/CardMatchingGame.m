//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Alex Smith on 27/10/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import "CardMatchingGame.h"
#import "Card.h"

@interface CardMatchingGame() // this is a class extension
@property (nonatomic, readwrite) NSInteger score; // we redeclare this property to be readwrite privately (i.e. only in the implementation)
@property (nonatomic, strong) NSMutableArray *cards; // of card
@property NSUInteger numCardMatching; // = 2 for 2 card matching game (default)
@property NSUInteger numberOfNonMatchedCardsInGamePrivate;

// private readwrite implementation of public properties
@property (readwrite) NSInteger lastScore;
@property (nonatomic, readwrite, strong) NSArray *lastCardsChosenToMatch;
@property (nonatomic, readwrite, strong) Card *lastCardChosen; // the last single card chosen
@property (nonatomic, strong) Deck *initialDeck; // hold onto the initial deck so more cards can be added at a later stage if needed
@end

@implementation CardMatchingGame

-(NSArray *)lastCardsGroupChosen
{
    if (!_lastCardsChosenToMatch) {
        _lastCardsChosenToMatch = [NSArray array];
    }
    
    return _lastCardsChosenToMatch;
}

-(NSMutableArray *)cards
{
    if (! _cards) { // lazy instantiation
        _cards = [[NSMutableArray alloc] init];
    }
    
    return _cards;
}

-(NSInteger)numberOfNonMatchedCardsInGame
{
    return self.numberOfNonMatchedCardsInGamePrivate;
}

-(instancetype)initWithCardCount:(NSUInteger)count
                       usingDeck:(Deck *)deck
               usingMatchModeNum:(NSUInteger)matchModeNum
{
    self = [super init]; // let the superclass initalise itself
    
    if (self) { // check for failure return of nil from the super init
        // cycle through all the cards in the passed in Deck (by drawing them randomly one at a time) and add them to our internal data structure (an array of Card objects)
        self.initialDeck = deck;
        for (int i = 0; i < count; i++) {
            Card *card = [self.initialDeck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else { // adding nil to an array will crash the program so we should check for this (in case someone passed in bad arguments)
                return nil;
                break;
            }
        }
        self.numCardMatching = matchModeNum;
        self.numberOfNonMatchedCardsInGamePrivate = [self.cards count];
    }
    
    return self;
}

-(void)addCardToGame
{
    Card *card = [self.initialDeck drawRandomCard];
    if (card) {
        [self.cards addObject:card];
        self.numberOfNonMatchedCardsInGamePrivate++;
    }
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return index < [self.cards count] ? self.cards[index] : nil; // make sure the argument is not out of bounds!
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

-(void)chooseCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index]; // the card to be chosen
    
    if (!card.isMatched) {
        if (card.isChosen) {
            card.chosen = NO;
        } else { // card is not matched and not chosen
            
            self.lastScore = 0; // reset this
            
            NSMutableArray *otherChosenCards = [NSMutableArray array];
            for (Card *currentCard in self.cards) {
                if (currentCard.isChosen && !currentCard.isMatched) {
                    [otherChosenCards addObject:currentCard];
                }
            }
            
            card.chosen = YES;
            self.lastCardChosen = card;
            
            NSMutableArray *allChosenCards = [NSMutableArray arrayWithArray:otherChosenCards];
            [allChosenCards addObject:card];
            
            if ([allChosenCards count] == self.numCardMatching) {
                
                self.lastCardsChosenToMatch = [NSArray arrayWithArray:allChosenCards];

                int matchScore = [card match:otherChosenCards];
                
                if (matchScore) {
                    self.lastScore = matchScore * MATCH_BONUS;
                    
                    for (Card *currentCard in allChosenCards) {
                        currentCard.matched = YES;
                        self.numberOfNonMatchedCardsInGamePrivate--;
                    }
                    
                } else {
                    self.lastScore = -MISMATCH_PENALTY;
                    
                    for (Card *currentCard in otherChosenCards) {
                        currentCard.chosen = NO;
                    }
                }
            }
            
            self.score += self.lastScore - COST_TO_CHOOSE;
        }
    }
}

@end