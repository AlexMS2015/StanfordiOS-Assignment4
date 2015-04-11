//
//  PlayingCard.h
//  Matchismo
//
//  Created by Alex Smith on 30/08/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

// A playing card has some properties that a vanilla card doesn't:

@property (strong, nonatomic) NSString *suit; // clubs, diamonds etc... nil will mean suit not set
@property (nonatomic) NSUInteger rank; // rank will be 0 (not set) to 13 (king)
+(NSArray *)validSuits;
+(NSUInteger)maxRank;

// NSUInteger is a typedef for an unsigned integer

@end
