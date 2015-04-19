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

-(void)viewDidLoad
{
    [super viewDidLoad];
    
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

-(IBAction)newGame:(UIBarButtonItem *)sender
{
    [self setupNewGame];
}

- (IBAction)tapCard:(UITapGestureRecognizer *)sender
{
    CGPoint touchPoint = [sender locationInView:self.cardDisplayView];
        
    UIView *card = [self.cardDisplayView hitTest:touchPoint withEvent:nil];
    if (![card isMemberOfClass:[UIView class]]) {
        int chosenButtonIndex = [self.cardButtons indexOfObject:card];
        [self.game chooseCardAtIndex:chosenButtonIndex];
        [self drawUI:NO];
    }
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
        self.cardButtons = [NSMutableArray array];
    }
    
    // display the cards in the grid
    
    /*for (UIView *cardView in self.cardDisplayView.subviews) {
        [cardView removeFromSuperview];
    }*/
    
    [self.cardDisplayView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [obj removeFromSuperview];
    }];
    
    //self.cardButtons = [NSMutableArray array];
    
    int cardIndex = 0;
    
    for (int i = 0; i < self.cardDisplayGrid.rowCount; i++) {
        for (int j = 0; j < self.cardDisplayGrid.columnCount; j++) {
            
            if (cardIndex < self.numberOfCards) {
    
                // THIS DOESN'T WORK??
                Card *cardToDisplay;
                for (int i = cardIndex; i < self.numberOfCards; i++) {
                    cardToDisplay = [self.game cardAtIndex:i];
                    if (!cardToDisplay.isMatched) {
                        break;
                    } else {
                        [self.cardButtons removeObjectAtIndex:i];
                        cardIndex--;
                    }
                }
                
                CGRect rectToDisplayCardIn = [self.cardDisplayGrid frameOfCellAtRow:i inColumn:j];
                UIView *cardView = [self viewForCard:cardToDisplay toDisplayInRect:rectToDisplayCardIn];

                //if (!cardToDisplay.isMatched) {
                if (!isNewGame) {
                    [self.cardButtons removeObjectAtIndex:cardIndex];
                }
                
                    [self.cardButtons insertObject:cardView atIndex:cardIndex];
                    [self.cardDisplayView addSubview:cardView];
                /*} else {
                    i-=1;
                    j-=1;
                }*/
                
                    
                cardIndex++;
            }
        }
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
