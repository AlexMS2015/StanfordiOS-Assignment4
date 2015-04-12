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

// the following 2 properties should be set by concrete subclasses in their viewDidLoad: method
@property NSUInteger numberCardMatchingMode;
@property NSUInteger numberOfCards;

-(Deck *)createDeck; // concrete class should implement this method
-(UIView *)cardViewForCard:(Card *)card toDisplayInRect:(CGRect)rect; // return a card to display.

@end
