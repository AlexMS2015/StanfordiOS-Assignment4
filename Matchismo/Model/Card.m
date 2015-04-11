//
//  Card.m
//  Matchismo
//
//  Created by Alex Smith on 30/08/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import "Card.h"

@implementation Card

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards)
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    
    return score;
}

@end
