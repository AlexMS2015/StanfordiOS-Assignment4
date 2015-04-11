//
//  Deck.m
//  Matchismo
//
//  Created by Alex Smith on 30/08/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards; // a private property because it's part of the internal implementation

//declaring a property makes space in the instance for the POINTER but does NOT allocate space in the heap for the object that the pointer POINTS to. i.e. the property needs to be allocated and initialised somewhere before we use it!
@end

@implementation Deck

-(NSMutableArray *)cards
{
    // add the following to the getter

    if (! _cards)
        _cards = [[NSMutableArray alloc] init]; // All properties start with a value of 0 (called nil for pointers to objects). This statements allocates space on the heap and initialises the object if the pointer has a value of 'nil' (points to nothing). This is called lazy instantiation.
    
    return _cards;
}


-(void)addCard:(Card *)card atTop:(BOOL)atTop
{
    // the following code will now always work because the getters sets up a blank mutable array if we call this method without having initialised the propery 'cards'.
    if (atTop) {
        [self.cards insertObject:card atIndex:0]; // calls the getter and hence alloc's and init's the array if this has not already occurred.
    } else {
        [self.cards addObject:card];
    }
}

-(void)addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

-(Card *)drawRandomCard
{
    
    Card *randomCard = nil;
    
    if ([self.cards count]) { // only run if there are > 0 cards in the array, otherwise calling self.cards[] will crash the program as the array is empty!
        unsigned index = arc4random() % [self.cards count]; // the remainder of a number divided by say 7 will always be less than 7.. in this case, index can never be > that the number of cards in the array 'cards'
        
        randomCard = self.cards[index]; // randomCard just points to the Card we have drawn in the heap... not creating a copy
        [self.cards removeObjectAtIndex:index]; // the cards array no longer points at the random Card we have drawn
    }
    

    
    return randomCard;
}

@end
