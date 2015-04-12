//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alex Smith on 30/08/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "Grid.h"
#import "PlayingCardView.h"

@interface CardGameViewController ()
// interface elements
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardDisplayView;

@property (strong, nonatomic) NSMutableArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game; // game model. Subclass should set this.
@property (strong, nonatomic) Grid *cardDisplayGrid;
@end

@implementation CardGameViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setupNewGame];
}

-(CardMatchingGame *)game
{
    if (!_game) {
        _game  = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                   usingDeck:[self createDeck]
                                           usingMatchModeNum:self.numberCardMatchingMode];
    }

    return _game;
}

-(UIView *)cardViewForCard:(Card *)card toDisplayInRect:(CGRect)rect
{
    return nil; // to be implemented by concrete class
}

-(Deck *)createDeck
{
    return nil; // // to be implemented by concrete class
}

-(Grid *)cardDisplayGrid
{
    if (!_cardDisplayGrid) {
        _cardDisplayGrid = [[Grid alloc] init];
    }
    
    return _cardDisplayGrid;
}

-(void)setupNewGame
{
    self.game  = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCards
                                                   usingDeck:[self createDeck]
                                           usingMatchModeNum:self.numberCardMatchingMode];
    
    [self drawUI:YES];
}

- (IBAction)newGame:(UIBarButtonItem *)sender
{
    [self setupNewGame];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self drawUI:NO];
}

-(void)drawUI:(BOOL)isNewGame
{
    if (isNewGame) {
        // reset the grid to original size (cards may have been added or removed)
        self.cardDisplayGrid.size = self.cardDisplayView.bounds.size;
        self.cardDisplayGrid.cellAspectRatio = 0.67;
        self.cardDisplayGrid.minimumNumberOfCells = self.numberOfCards;
        self.cardDisplayGrid.minCellHeight = 96;
        self.cardDisplayGrid.minCellWidth = 64;
    }
        
    // display the cards in the grid
    int cardIndex = 0;
    for (int i = 0; i < self.cardDisplayGrid.rowCount; i++) {
        for (int j = 0; j < self.cardDisplayGrid.columnCount; j++) {
                
            Card *cardToDisplay = [self.game cardAtIndex:cardIndex];
            CGRect rectToDisplayCardIn = [self.cardDisplayGrid frameOfCellAtRow:i inColumn:j];
                
            UIView *nextCard = [self cardViewForCard:cardToDisplay toDisplayInRect:rectToDisplayCardIn];
                
            [self.cardButtons addObject:nextCard];
            [self.cardDisplayView addSubview:nextCard];
                
            cardIndex++;
        }
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
