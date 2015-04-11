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
        
        for (NSNumber *number in [SetCard validNumbers]) {
            for (NSString *symbol in [SetCard validSymbols]) {
                for (NSNumber *shading in [SetCard validShadings]) {
                    for (UIColor *color in [SetCard validColours]) {
                        SetCard *setCard = [[SetCard alloc] init];
                        
                        setCard.number = [number intValue];
                        setCard.symbol = symbol;
                        setCard.shading = [shading floatValue];
                        setCard.colour = color;
                        
                        [self addCard:setCard];
                    }
                }
            }
        }
        
    }
    
    return self;
}

@end
