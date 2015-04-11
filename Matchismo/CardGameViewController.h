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

@interface CardGameViewController : UIViewController

@property NSUInteger numberCardMatchingMode; // 2 is default set by this class.

-(Deck *)createDeck; // concrete class should implement this method
-(NSAttributedString *)titleForCard:(Card *)card; // how you want the title of your card type shown
-(UIImage *)backgroundImageForCard:(Card *)card; // what background image you want for your card

@end
