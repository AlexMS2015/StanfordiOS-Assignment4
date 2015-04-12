//
//  SetCard.m
//  Matchismo
//
//  Created by Alex Smith on 6/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import "SetCard.h"
#import "SetCardDeck.h"

@implementation SetCard

-(BOOL)doThreeSetCardsMatchWithAttributes:(NSArray *)cardAttributes;
{
    int attributeAllEqual = 0;
    int attributeAllUnequal = 0;
    
    for (NSArray *cardAttribute in cardAttributes) {
    
        if ([cardAttribute count] == 3) {
        
            BOOL oneAndTwo = [cardAttribute[0] isEqualToNumber: cardAttribute[1]];
            BOOL oneAndThree = [cardAttribute[0] isEqualToNumber: cardAttribute[2]];
            BOOL twoAndThree = [cardAttribute[1] isEqualToNumber: cardAttribute[2]];
            
            if (oneAndTwo && oneAndThree && twoAndThree) {
                attributeAllEqual +=1;
            } else if (!oneAndTwo && !oneAndThree && !twoAndThree) {
                attributeAllUnequal += 1;
            }
        }
    }

    return (attributeAllEqual == 4 | attributeAllUnequal == 4) ? YES : NO;
}

-(int)match:(NSArray *)otherCards
{
    int score = 0;

    NSMutableArray *allCards = [NSMutableArray arrayWithArray:otherCards];
    [allCards addObject:self];
    
    NSMutableArray *cardNumbers = [NSMutableArray array];
    NSMutableArray *cardSymbols = [NSMutableArray array];
    NSMutableArray *cardShadings = [NSMutableArray array];
    NSMutableArray *cardColours = [NSMutableArray array];

    for (SetCard *card in allCards) {
        [cardNumbers addObject:card.number];
        [cardNumbers addObject:card.symbol];
        [cardNumbers addObject:card.shading];
        [cardNumbers addObject:card.colour];
    }
    
    NSArray *cardAttributes = @[cardNumbers, cardSymbols, cardShadings, cardColours];
    
    if ([self doThreeSetCardsMatchWithAttributes:cardAttributes]) score = 100;

    return score;
}

@end
