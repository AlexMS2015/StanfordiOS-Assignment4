//
//  Deck.h
//  Matchismo
//
//  Created by Alex Smith on 30/08/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

-(void)addCard:(Card *)card atTop:(BOOL)atTop;
-(void)addCard:(Card *)card; // arguments to methods are never optional so we declare an option without the second argument - it will simply call the method with 2 arguments.

-(Card *)drawRandomCard; // returns a pointer to an instance of a Card in the heap

@end
