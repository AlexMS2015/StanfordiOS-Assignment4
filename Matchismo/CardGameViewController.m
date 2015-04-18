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

@interface CardGameViewController ()
// interface elements
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardDisplayView;

@property (strong, nonatomic) NSMutableArray *cardButtons; // array to hold the card views
@property (strong, nonatomic) CardMatchingGame *game; // game model. Subclass should set this.
@property (strong, nonatomic) Grid *cardDisplayGrid;
@end

@implementation CardGameViewController

#pragma mark - Properties

-(CardMatchingGame *)game
{
    if (!_game) {
        _game  = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCards
                                                   usingDeck:[self createDeck]
                                           usingMatchModeNum:self.numberCardMatchingMode];
    }
    
    return _game;
}

-(Grid *)cardDisplayGrid
{
    if (!_cardDisplayGrid) {
        _cardDisplayGrid = [[Grid alloc] init];
    }
    
    return _cardDisplayGrid;
}

-(NSMutableArray *)cardButtons
{
    if (!_cardButtons) {
        _cardButtons = [NSMutableArray array];
    }
    
    return _cardButtons;
}

#pragma mark - View Life Cycle

-(void)viewDidAppear:(BOOL)animated // this needs to be fixed as a new game is created everytime the user clicks away from the tab and then back onto it
{
    [super viewDidAppear:animated];
    
    [self setupNewGame];
}

#pragma mark

-(UIView *)viewForCard:(Card *)card toDisplayInRect:(CGRect)rect
{
    return nil; // to be implemented by concrete class
}

-(Deck *)createDeck
{
    return nil; // // to be implemented by concrete class
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

#define CARD_ASPECT_RATIO 0.67
#define MIN_CARD_HEIGHT 96
#define MIN_CARD_WIDTH 64

-(void)drawUI:(BOOL)isNewGame
{
    if (isNewGame) {
        // reset the grid to original size (cards may have been added or removed)
        self.cardDisplayGrid.size = self.cardDisplayView.bounds.size;
        self.cardDisplayGrid.cellAspectRatio = CARD_ASPECT_RATIO;
        self.cardDisplayGrid.minimumNumberOfCells = self.numberOfCards;
        //self.cardDisplayGrid.minCellHeight = MIN_CARD_HEIGHT; // delete this code?
        //self.cardDisplayGrid.minCellWidth = MIN_CARD_WIDTH; // delete this code?
        
        // reset our array that holds the card views
        self.cardButtons = [NSMutableArray array];
    }
    
    NSLog(@"%d",self.cardDisplayGrid.rowCount);
    NSLog(@"%d",self.cardDisplayGrid.columnCount);
    
    // display the cards in the grid
    int cardIndex = 0;
    
    for (int i = 0; i < self.cardDisplayGrid.rowCount; i++) {
        for (int j = 0; j < self.cardDisplayGrid.columnCount; j++) {
            
            if (cardIndex < self.numberOfCards) {
                Card *cardToDisplay = [self.game cardAtIndex:cardIndex];
                CGRect rectToDisplayCardIn = [self.cardDisplayGrid frameOfCellAtRow:i inColumn:j];
                
                UIView *cardView = [self viewForCard:cardToDisplay toDisplayInRect:rectToDisplayCardIn];
                
                // self.cardButtons[cardIndex] = [self viewForCard:cardToDisplay toDisplayInRect:rectToDisplayCardIn]; // will changing the view inside the cardbutton array also change the view inside the cardDisplayView?? Do they point to the same location?
                //[self.cardDisplayView setNeedsDisplay];
                
                if (isNewGame) {
                    [self.cardButtons addObject:cardView];
                    [self.cardDisplayView addSubview:cardView];
                } /*else {
                   if (self.game.lastCardChosen == cardToDisplay) { // FIX THIS LINE
                   
                   // remove the old view for card just chosen
                   [self.cardButtons[cardIndex] removeFromSuperview];
                   [self.cardButtons removeObjectAtIndex:cardIndex];
                   
                   // add new view for card just chosen
                   [self.cardButtons insertObject:cardView atIndex:cardIndex];
                   [self.cardDisplayView addSubview:cardView];
                   }
                   }*/
                
                cardIndex++;
            }
        }
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
