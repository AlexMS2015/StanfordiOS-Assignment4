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
#import "SetCardView.h"

@interface CardGameViewController () <UIDynamicAnimatorDelegate>
// interface elements
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *cardDisplayView;

@property (nonatomic) NSUInteger numberOfCardsInPlay;
@property (strong, nonatomic) NSMutableArray *cardButtons; // array to hold the card views
@property (strong, nonatomic) Grid *cardDisplayGrid;
@property (strong, nonatomic) CardMatchingGame *game; // game model
@property (strong, nonatomic) UIDynamicAnimator *animator;
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
    
    self.cardDisplayView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchCards:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    [self setupNewGame];
}

-(void)viewDidLayoutSubviews
{
    [self drawCardGrid];
    [self drawUI];
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

-(void)updateCardView:(UIView *)cardView withCard:(Card *)card
{
    
}

#pragma mark - Other

-(void)setupNewGame
{
    self.game  = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsInitial
                                                   usingDeck:[self createDeck]
                                           usingMatchModeNum:self.numberCardMatchingMode];
    
    self.numberOfCardsInPlay = self.numberOfCardsInitial;
    if ([self.cardButtons count]) {
        [self makeWayForNewGame];
    }
    self.cardButtons = [NSMutableArray array];
    [self drawCardGrid];
}

-(void)updateNumCellsInGrid
{
    if (self.removeMatchCardsFromInterface) {
        self.cardDisplayGrid.minimumNumberOfCells = self.game.numberOfNonMatchedCardsInGame;
    } else {
        self.cardDisplayGrid.minimumNumberOfCells = self.numberOfCardsInPlay;
    }
}

#define MAX_NUMBER_CARDS_ALLOWED_ONSCREEN 90
-(void)addCardsToGame:(NSUInteger)numCardsToAdd
{
    if (self.game.numberOfNonMatchedCardsInGame >= MAX_NUMBER_CARDS_ALLOWED_ONSCREEN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"Maximum number of cards reached"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        int oldNumCards = self.game.numberOfNonMatchedCardsInGame;
        for (NSUInteger i = 0; i < numCardsToAdd; i++) {
            [self.game addCardToGame];
            if (oldNumCards == self.game.numberOfNonMatchedCardsInGame) { // deck is empty!
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"No more cards in deck"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                break;
            } else {
                self.numberOfCardsInPlay++;
            }
        }
        [self drawUI];
    }

}

#pragma mark - Action Methods

-(IBAction)newGame:(UIBarButtonItem *)sender
{
    [self setupNewGame];
    [self drawUI];
}

- (IBAction)tapCard:(UITapGestureRecognizer *)sender
{
    if (self.animator) {
        self.animator = nil;
        [self drawUI];
    } else {
        CGPoint touchPoint = [sender locationInView:self.cardDisplayView];
        
        UIView *card = [self.cardDisplayView hitTest:touchPoint withEvent:nil];
        if (![card isMemberOfClass:[UIView class]]) {
            int chosenButtonIndex = [self.cardButtons indexOfObject:card];
            [self.game chooseCardAtIndex:chosenButtonIndex];
            [self drawUI];
        }
    }
}

#pragma mark - UI Drawing

#define CARD_ASPECT_RATIO 0.67
-(void)drawCardGrid
{
    self.cardDisplayGrid = [[Grid alloc] init];
    self.cardDisplayGrid.size = self.cardDisplayView.bounds.size;
    self.cardDisplayGrid.cellAspectRatio = CARD_ASPECT_RATIO;
    self.cardDisplayGrid.minimumNumberOfCells = self.numberOfCardsInPlay;
}

-(CGRect)dealFromSpotRect
{
    CGRect rectToDealCardsFrom = [self.cardDisplayGrid frameOfCellAtRow:self.cardDisplayGrid.rowCount
                                                               inColumn:self.cardDisplayGrid.columnCount];
    rectToDealCardsFrom.origin.x += self.cardDisplayGrid.size.width;
    rectToDealCardsFrom.origin.y += self.cardDisplayGrid.size.height;
    
    return rectToDealCardsFrom;
}

#define DEAL_NEWCARD_MOVE_DURATION 0.8
#define MOVE_EXISTING_CARD_DURATION 0.5

-(void)drawUI
{
    [self updateNumCellsInGrid];
    
    // display the cards in the grid
    int cardIndex = 0;
    for (int i = 0; i < self.cardDisplayGrid.rowCount; i++) {
        for (int j = 0; j < self.cardDisplayGrid.columnCount; j++) {
    
            if (cardIndex < self.numberOfCardsInPlay) {
                
                if (self.removeMatchCardsFromInterface == YES) {
                    while ([self.game cardAtIndex:cardIndex].isMatched) {
                        [self animateOutCardAtIndex:cardIndex];
                        cardIndex++;
                    }
                }
                
                if (cardIndex >= self.numberOfCardsInPlay) {
                    break;
                }
                
                Card *cardToDisplay = [self.game cardAtIndex:cardIndex];
                CGRect rectToDisplayCardIn = [self.cardDisplayGrid frameOfCellAtRow:i inColumn:j];
                
                if (cardIndex >= [self.cardButtons count]) {
                    UIView *cardView = [self viewForCard:cardToDisplay toDisplayInRect:[self dealFromSpotRect]];
                    [self.cardDisplayView addSubview:cardView];
                    [self.cardButtons addObject:cardView];
                    
                    int delayFactor;
                    if (cardIndex < self.numberOfCardsInitial) { // is this an 'added' card or are we laying out one of the original cards in a new game?
                        delayFactor = cardIndex;
                    } else {
                        delayFactor = 0;
                    }
                    [self animateCard:cardView
                      withDelayFactor:delayFactor
                          andDuration:DEAL_NEWCARD_MOVE_DURATION
                               toRect:rectToDisplayCardIn];
                    
                } else if ([self.cardDisplayView.subviews containsObject:self.cardButtons[cardIndex]]) {
                    
                    UIView *viewForCurrentCard = (UIView *)self.cardButtons[cardIndex];
                    
                    if (cardToDisplay.isMatched) {
                        NSLog(@"matched");
                        [self showCardAsMatchedWithView:viewForCurrentCard];
                    }

                    // if a card has moved, we need to animate it moving to new location
                    if (!CGRectEqualToRect(rectToDisplayCardIn, viewForCurrentCard.frame) ) {
                        [self animateCard:viewForCurrentCard
                          withDelayFactor:0.0
                              andDuration:MOVE_EXISTING_CARD_DURATION
                                   toRect:rectToDisplayCardIn];
                    }
                    [self updateCardView:viewForCurrentCard withCard:(Card *)cardToDisplay];
                }
                cardIndex++;
            }
        }
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

#pragma mark - Animations

-(void)showCardAsMatchedWithView:(UIView *)cardView
{
    [[UIColor grayColor] setFill];
    UIRectFill(cardView.bounds);
}

#define CARD_EXIT_DURATION 1.5
-(void)animateOutCardAtIndex:(int)cardIndex
{
    UIView *viewToAnimate = self.cardButtons[cardIndex];
    
    CGRect topLeftOffScreen = CGRectMake(-2*viewToAnimate.bounds.size.width, -2*viewToAnimate.bounds.size.height, viewToAnimate.bounds.size.width, viewToAnimate.bounds.size.height);
    
    if (!CGRectEqualToRect(topLeftOffScreen, viewToAnimate.frame)) {
        [UIView animateWithDuration:CARD_EXIT_DURATION
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             viewToAnimate.frame = topLeftOffScreen; }
                         completion:^(BOOL finished){
                             [viewToAnimate removeFromSuperview];
                         }];
    }
}

-(void)animateCard:(UIView *)cardView
   withDelayFactor:(float)delayFactor
       andDuration:(float)duration
            toRect:(CGRect)rect
{
    [UIView animateWithDuration:duration
                          delay:delayFactor * duration / 4
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         cardView.frame = rect; }
                     completion:NULL];
}

-(void)makeWayForNewGame
{
    CGPoint offScreenPoint = CGPointMake(-self.cardDisplayView.bounds.size.width/2, -self.cardDisplayView.bounds.size.height/2);
    
    [self.cardButtons enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger index, BOOL *stop)
     {
         [UIView animateWithDuration:1.0
                               delay:0
                             options:UIViewAnimationOptionCurveEaseOut
                          animations:^{
                              obj.center = offScreenPoint;
                              obj.alpha = 0.0;
                          }
                          completion:NULL];
     }];
    
}

-(void)pinchCards:(UIPinchGestureRecognizer *)gesture
{
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        float scaleFactor = 0.8;//gesture.scale;
        
        self.cardDisplayView.bounds = CGRectInset(self.cardDisplayView.bounds, self.cardDisplayView.bounds.size.width * (1 - scaleFactor), self.cardDisplayView.bounds.size.height * (1 - scaleFactor));

        NSLog(@"scale: %f", gesture.scale);
        gesture.scale = 1.0;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
    
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardDisplayView];
        self.animator.delegate = self;
        
        CGPoint centerPoint = CGPointMake(self.cardDisplayView.bounds.size.width/2.0, self.cardDisplayView.bounds.size.height/2.0);
        
        [self.cardDisplayView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            UISnapBehavior *snapToCentre = [[UISnapBehavior alloc] initWithItem:obj snapToPoint:centerPoint];
            [self.animator addBehavior:snapToCentre];
        }];
    }
}

@end
