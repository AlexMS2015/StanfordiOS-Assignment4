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
        if ([self.game cardAtIndex:chosenButtonIndex].isMatched) {
            self.numberOfCards =12;
            [self drawCardGrid];
        }
        [self drawUI:NO];
    }
}

#define CARD_ASPECT_RATIO 0.67
#define NUMBER_OF_COLUMNS 3
#define MIN_CARD_HEIGHT 96
#define MIN_CARD_WIDTH 64

-(void)drawCardGrid
{
    self.cardDisplayGrid = [[Grid alloc] init];
    self.cardDisplayGrid.size = self.cardDisplayView.bounds.size;
    self.cardDisplayGrid.cellAspectRatio = CARD_ASPECT_RATIO;
    self.cardDisplayGrid.minimumNumberOfCells = self.numberOfCards;
    NSLog(@"rows: %d", self.cardDisplayGrid.rowCount);
    NSLog(@"columns: %d", self.cardDisplayGrid.columnCount);
}

-(void)drawUI:(BOOL)isNewGame
{
    if (isNewGame) {
        // reset the grid to original size (cards may have been added or removed)
        [self drawCardGrid];
    }
    
    // display the cards in the grid
    
    if (self.cardDisplayView.subviews) {
        [self.cardDisplayView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [obj removeFromSuperview];
        }];
    }
    
    int cardIndex = 0;
    
    for (int i = 0; i < self.cardDisplayGrid.rowCount; i++) {
        for (int j = 0; j < self.cardDisplayGrid.columnCount; j++) {
            
            if (cardIndex < self.numberOfCards) {
                
                Card *cardToDisplay = [self.game cardAtIndex:cardIndex];
                CGRect rectToDisplayCardIn = [self.cardDisplayGrid frameOfCellAtRow:i inColumn:j];
                UIView *cardView = [self viewForCard:cardToDisplay toDisplayInRect:rectToDisplayCardIn];

                /*if (!isNewGame) {
                    //[self.cardButtons[cardIndex] removeFromSuperview];
                    [self.cardButtons removeObjectAtIndex:cardIndex];
                }*/
                self.cardButtons[cardIndex] = cardView;
                
                [self.cardDisplayView addSubview:cardView];

                if (cardToDisplay.isMatched) {
                    //i-=1;
                    j-=1;
                    //self.cardDisplayGrid.minimumNumberOfCells -=1;
                    [self.cardButtons[cardIndex] removeFromSuperview];
                }

                cardIndex++;
            }
        }
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
