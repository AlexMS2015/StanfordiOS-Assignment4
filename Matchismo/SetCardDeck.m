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
        
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                for (int k = 0; k < 3; k++) {
                    for (int l = 0; l < 3; l++) {
                        SetCard *setCard = [[SetCard alloc] init];
                        
                        setCard.number = [NSNumber numberWithInteger:i];
                        setCard.symbol = [NSNumber numberWithInteger:j];
                        setCard.shading = [NSNumber numberWithInteger:k];
                        setCard.colour = [NSNumber numberWithInteger:l];
                        
                        [self addCard:setCard];
                    }
                }
            }
        }
        
    }
    
    return self;
}

@end
