//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Alex Smith on 30/08/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//
// This is an abstract class. See below for methods to implement in concrete class.

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "Grid.h"

@interface CardGameViewController : UIViewController

// the following 2 properties should be set by concrete subclasses in their awakeFromNib: method
@property NSUInteger numberCardMatchingMode;
@property NSUInteger numberOfCardsInitial;
@property BOOL removeMatchCardsFromInterface;

-(void)addCardsToGame:(NSUInteger)numCardsToAdd;
-(Deck *)createDeck; // concrete class should implement this method
-(UIView *)viewForCard:(Card *)card toDisplayInRect:(CGRect)rect; // return a new card view to display a particular card at a particular location
-(void)updateCardView:(UIView *)cardView
             withCard:(Card *)card; // update a cards contents (e.g. if it has been chosen)
@end
