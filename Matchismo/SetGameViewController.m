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
}

-(Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    NSMutableAttributedString *cardTitle = [[NSMutableAttributedString alloc] init];
    SetCard *setCard = (SetCard *)card;

    for (int i = 0; i < setCard.number; i++) {
        
        UIColor *shadedColor = [setCard.colour colorWithAlphaComponent:setCard.shading];
        
        NSAttributedString *attributedSymbolString = [[NSAttributedString alloc] initWithString:setCard.symbol attributes:@{ NSForegroundColorAttributeName : shadedColor }];
        
        [cardTitle appendAttributedString:attributedSymbolString];
    }

    return cardTitle;
}

-(UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:@"setcardback"];
}

@end
