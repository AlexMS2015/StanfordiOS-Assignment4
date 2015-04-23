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

#pragma mark - Abstract Methods

-(UIView *)viewForCard:(Card *)card toDisplayInRect:(CGRect)rect
{
    return nil; // to be implemented by concrete class
}

-(Deck *)createDeck
{
    return nil; // to be implemented by concrete class
}

-(void)updateCardView:(UIView *)cardView withCard:(Card *)card toDisplayInRect:(CGRect)rectToDisplayCardIn
{
    
}

#pragma mark - Other

-(void)setupNewGame
{
    self.game  = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsInitial
                                                   usingDeck:[self createDeck]
                                           usingMatchModeNum:self.numberCardMatchingMode];
    
    [self drawUI:YES];
}

#pragma mark - Action Methods

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
            self.cardDisplayGrid.minimumNumberOfCells -= self.numberCardMatchingMode;
            NSLog(@"rows: %d", self.cardDisplayGrid.rowCount);
            NSLog(@"columns: %d", self.cardDisplayGrid.columnCount);
        }
        [self drawUI:NO];
    }
}

#pragma mark - UI Drawing

#define CARD_ASPECT_RATIO 0.67
-(void)drawCardGrid
{
    self.cardDisplayGrid = [[Grid alloc] init];
    self.cardDisplayGrid.size = self.cardDisplayView.bounds.size;
    self.cardDisplayGrid.cellAspectRatio = CARD_ASPECT_RATIO;
    self.cardDisplayGrid.minimumNumberOfCells = self.numberOfCardsInitial;
}

-(CGRect)dealFromSpotRect
{
    CGRect rectToDealCardsFrom = [self.cardDisplayGrid frameOfCellAtRow:self.cardDisplayGrid.rowCount
                                                               inColumn:self.cardDisplayGrid.columnCount];
    rectToDealCardsFrom.origin.x += self.cardDisplayGrid.size.width;
    rectToDealCardsFrom.origin.y += self.cardDisplayGrid.size.height;
    
    return rectToDealCardsFrom;
}

-(void)drawUI:(BOOL)isNewGame
{
    if (isNewGame) {
        self.numberOfCardsInPlay = self.numberOfCardsInitial;
        
        if ([self.cardButtons count]) {
            [self makeWayForNewGame];
        }
        self.cardButtons = [NSMutableArray array];
        
        [self drawCardGrid];
    }
    
    // display the cards in the grid
    int cardIndex = 0;
    for (int i = 0; i < self.cardDisplayGrid.rowCount; i++) {
        for (int j = 0; j < self.cardDisplayGrid.columnCount; j++) {
    
            if (cardIndex < self.numberOfCardsInPlay) {
                
                while ([self.game cardAtIndex:cardIndex].isMatched) {
                    
                    // need to somehow flip the latest chosen card over before animating it out!!
                    
                    NSLog(@"Card %d is matched", cardIndex + 1);
                    
                    [self animateOutCardAtIndex:cardIndex];
                    cardIndex++;
                    
                    // THIS WHOLE THING DOESN'T WORK.. DRAW IT OUT ON PAPER???
                }
                
                if (cardIndex >= self.numberOfCardsInPlay) {
                    break;
                }
                
                Card *cardToDisplay = [self.game cardAtIndex:cardIndex];
                CGRect rectToDisplayCardIn = [self.cardDisplayGrid frameOfCellAtRow:i inColumn:j];
                
                if (isNewGame) {
                    UIView *cardView = [self viewForCard:cardToDisplay toDisplayInRect:[self dealFromSpotRect]];
                    [self.cardDisplayView addSubview:cardView];
                    [self.cardButtons addObject:cardView];
                    [self dealCard:cardView atIndex:cardIndex toRect:rectToDisplayCardIn];
                
                // if the view is already in the grid then just update it... don't get an entirely new view
                } else if ([self.cardDisplayView.subviews containsObject:self.cardButtons[cardIndex]]) {
                    [self updateCardView:self.cardButtons[cardIndex]
                                withCard:(Card *)cardToDisplay
                         toDisplayInRect:rectToDisplayCardIn];
                }
                cardIndex++;
            }
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - Animations

#define CARD_EXIT_DURATION 1.5
-(void)animateOutCardAtIndex:(int)cardIndex
{
    UIView *viewToAnimate = self.cardButtons[cardIndex];
    
    if (viewToAnimate.center.x != -100) { //EVERY SINGLE MATCHED CARD IS RE-ANIMATED... THIS IS A MASSIVE RESOURCE DRAG... DON'T DO THIS
        
        CGRect topLeftOffScreen = CGRectMake(-2*viewToAnimate.bounds.size.width, -2*viewToAnimate.bounds.size.height, viewToAnimate.bounds.size.width, viewToAnimate.bounds.size.height);
        
        [UIView animateWithDuration:CARD_EXIT_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             viewToAnimate.frame = topLeftOffScreen; }
                         completion:NULL];
    }
    
}

#define CARD_DEAL_DURATION 1.0
-(void)dealCard:(UIView *)cardView atIndex:(float)index toRect:(CGRect)rect
{
    [UIView animateWithDuration:CARD_DEAL_DURATION
                          delay:index * CARD_DEAL_DURATION / 4
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         cardView.frame = rect; }
                     completion:NULL];
}

-(void)makeWayForNewGame
{
    //CGRect centerCardRect = CGRectMake(self.view.center.x - self.cardDisplayGrid.cellSize.width/2, self.view.center.y - self.cardDisplayGrid.cellSize.height/2, self.cardDisplayGrid.cellSize.width, self.cardDisplayGrid.cellSize.height);
    
    CGPoint centerOfCardView = CGPointMake(-self.cardDisplayView.bounds.size.width/2, -self.cardDisplayView.bounds.size.height/2);
    
    [self.cardButtons enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger index, BOOL *stop)
     {
         [UIView animateWithDuration:1.0
                               delay:0
                             options:UIViewAnimationOptionCurveEaseOut
                          animations:^{
                              obj.center = centerOfCardView;
                              obj.alpha = 0.0;
                          }
                          completion:NULL];
     }];
    
}

#pragma mark - Junk Code

-(void)junkMethod
{
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
}

@end
