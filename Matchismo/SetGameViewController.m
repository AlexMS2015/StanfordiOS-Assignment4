//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Alex Smith on 6/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberCardMatchingMode = 3;
    self.numberOfCards = 12;
}

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

@end
