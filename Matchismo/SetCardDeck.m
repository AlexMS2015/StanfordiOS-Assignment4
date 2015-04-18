//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Alex Smith on 6/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        
        for (int i = 1; i < 4; i++) {
            for (int j = 0; j < 3; j++) {
                for (int k = 0; k < 3; k++) {
                    for (int l = 0; l < 3; l++) {
                        SetCard *setCard = [[SetCard alloc] init];
                        
                        setCard.number = i;
                        setCard.symbol = j;
                        setCard.shading = k;
                        setCard.colour = l;
                        
                        [self addCard:setCard];
                    }
                }
            }
        }
        
    }
    
    return self;
}

@end
