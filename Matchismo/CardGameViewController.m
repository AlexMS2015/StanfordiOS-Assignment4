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

@property (nonatomic) NSUInteger numberOfCardsInPlay;
@property (strong, nonatomic) NSMutableArray *cardButtons; // array to hold the card views
@property (strong, nonatomic) CardMatchingGame *game; // game model. Subclass should set this.
@property (strong, nonatomic) Grid *cardDisplayGrid;
@end

@implementation CardGameViewController

#pragma mark - Properties

-(CardMatchingGame *)game
{
    if (!_game) {
        _game  = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsInitial
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
    self.game  = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsInitial
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
            [self animateOutMatchedCards];
            self.numberOfCardsInPlay -= self.numberCardMatchingMode;
            [self drawCardGrid];
        }
        [self drawUI:NO];
    }
}

#define CARD_ASPECT_RATIO 0.67
#define MIN_CARD_HEIGHT 96
#define MIN_CARD_WIDTH 64

-(void)drawCardGrid
{
    self.cardDisplayGrid = [[Grid alloc] init];
    self.cardDisplayGrid.size = self.cardDisplayView.bounds.size;
    self.cardDisplayGrid.cellAspectRatio = CARD_ASPECT_RATIO;
    self.cardDisplayGrid.minimumNumberOfCells = self.numberOfCardsInPlay;
    NSLog(@"rows: %d", self.cardDisplayGrid.rowCount);
    NSLog(@"columns: %d", self.cardDisplayGrid.columnCount);
}

-(void)animateOutMatchedCards
{
    for (int cardNum = 0; cardNum < self.numberOfCardsInPlay; cardNum++) {
        Card *card = [self.game cardAtIndex:cardNum];
        
        if (card.isMatched) {
            
            UIView *cardView = self.cardButtons[cardNum];
            
            UIView *viewToAnimate = [self viewForCard:card toDisplayInRect:cardView.frame];
            
            [UIView animateWithDuration:2.0
                             animations:^{
                                 viewToAnimate.alpha = 0.0;
                             }
                             completion:^(BOOL fin){NSLog(@"finished? %d", fin);}];
        }
        if (card.isMatched) {
            break;
        }
    }
}

-(void)testUI
{
    int cardIndex = 0;

    while (cardIndex < self.numberOfCardsInPlay) {
        
        while ([self.game cardAtIndex:cardIndex].isMatched) {
            [self.cardButtons[cardIndex] removeFromSuperview];
                cardIndex++;
            }
        Card *cardToDisplay = [self.game cardAtIndex:cardIndex];
        
        int row = cardIndex / self.cardDisplayGrid.columnCount;
        int column = cardIndex % self.cardDisplayGrid.columnCount;
        
        CGRect rectToDisplayCardIn = [self.cardDisplayGrid frameOfCellAtRow:row inColumn:column];
        
        if (![self.cardDisplayView.subviews containsObject:self.cardButtons[cardIndex]]) {
            UIView *cardView = [self viewForCard:cardToDisplay toDisplayInRect:rectToDisplayCardIn];
            [self.cardDisplayView addSubview:cardView];
        } else {
            NSLog(@"already here");
        }
        
        // WRITE PSEUDE CODE THIS IS WAYYYY TOO SLOW THIS WAY!!!
        

        
        cardIndex++;
    }
}

-(void)drawUI:(BOOL)isNewGame
{
    if (isNewGame) {
        self.numberOfCardsInPlay = self.numberOfCardsInitial;
        [self drawCardGrid];
    }
    
    // display the cards in the grid
    [self testUI];
    
    // remove all existing card views
    /*if (self.cardDisplayView.subviews) {
        [self.cardDisplayView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            [obj removeFromSuperview];
        }];
    }*/
    
    /*
    int cardIndex = 0;
    for (int i = 0; i < self.cardDisplayGrid.rowCount; i++) {
        for (int j = 0; j < self.cardDisplayGrid.columnCount; j++) {
            
            if (cardIndex < self.numberOfCardsInitial) {
                
                //NSLog(@"Row: %d, Col: %d, Card: %d", i+1, j+1, cardIndex+1);
                
                // get the next NON-MATCHED card to display
                while ([self.game cardAtIndex:cardIndex].isMatched) {
                    [self.cardButtons[cardIndex] removeFromSuperview];
                    cardIndex++;
                }
                Card *cardToDisplay = [self.game cardAtIndex:cardIndex];
                
                CGRect rectToDisplayCardIn = [self.cardDisplayGrid frameOfCellAtRow:i inColumn:j];
                UIView *cardView = [self viewForCard:cardToDisplay toDisplayInRect:rectToDisplayCardIn];
                
                // replace the view in the cardButtons array with the updated one
                if (!isNewGame) {
                    [self.cardButtons[cardIndex] removeFromSuperview];
                }
                self.cardButtons[cardIndex] = cardView;
                
                //if (!cardToDisplay.isMatched)
                [self.cardDisplayView addSubview:cardView];
                
                cardIndex++;
            }
        }
    }
    */

    

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

@end
