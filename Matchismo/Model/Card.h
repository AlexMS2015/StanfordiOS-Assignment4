//
//  Card.h
//  Matchismo
//
//  Created by Alex Smith on 30/08/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter = isChosen) BOOL chosen; // changes the getter's name from 'chosen' to 'isChosen'
@property (nonatomic, getter = isMatched) BOOL matched;

-(int)match:(NSArray *)otherCards; // returns an int and takes an NSArray called otherCards as its argument


@end
