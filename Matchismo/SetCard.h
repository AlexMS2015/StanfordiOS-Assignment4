//
//  SetCard.h
//  Matchismo
//
//  Created by Alex Smith on 6/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property NSUInteger number;
@property (nonatomic, strong) NSString *symbol;
@property float shading;
@property (nonatomic, strong) UIColor *colour;

+(NSArray *)validNumbers;
+(NSArray *)validSymbols;
+(NSArray *)validShadings;
+(NSArray *)validColours;

@end
