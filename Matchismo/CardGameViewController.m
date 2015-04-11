//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alex Smith on 30/08/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"

@interface CardGameViewController ()
// interface elements
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastCardChosenLabel;
@property (strong, nonatomic) NSMutableArray *gameHistory;

@property (strong, nonatomic) CardMatchingGame *game; // game model. Subclass should set this.
@end

@implementation CardGameViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.numberCardMatchingMode = 2; // default... subclasses can set their own value
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

-(Deck *)createDeck
{
    return nil;
}

-(NSMutableArray *)gameHistory
{
    if (!_gameHistory) {
        _gameHistory = [NSMutableArray array];
    }
    
    return _gameHistory;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PlayingCardGameHistory"] || [segue.identifier isEqualToString:@"SetCardGameHistory"]) {
        if ([segue.destinationViewController isMemberOfClass:[HistoryViewController class]]) {
            HistoryViewController *hvc = (HistoryViewController *)segue.destinationViewController;
            hvc.gameHistory = [NSArray arrayWithArray:self.gameHistory];
        }
    }
}

- (IBAction)newGame:(UIBarButtonItem *)sender
{
    self.game  = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                   usingDeck:[self createDeck]
                                           usingMatchModeNum:self.numberCardMatchingMode];
    
    [self drawUI:YES];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self drawUI:NO];
}

-(void)drawUI:(BOOL)isNewGame
{
    // update the display for each card
    for (UIButton *cardButton in self.cardButtons) {
        
        // Get the card we selected in the UI from the model
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
                
        // set the title and image
        NSAttributedString *cardTitle = [[NSAttributedString alloc] init];
        UIImage *cardImage = [self backgroundImageForCard:card];;
        if (card.isChosen) {
            cardTitle = [self titleForCard:card];
            cardImage = [UIImage imageNamed:@"cardfront"];
        }

        [cardButton setAttributedTitle:cardTitle forState:UIControlStateNormal];
        [cardButton setBackgroundImage:cardImage forState:UIControlStateNormal];
        
        cardButton.enabled = !card.isMatched;
    }

    if (!isNewGame) {
        
        self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
        
        NSMutableAttributedString *lastCardSelected = [[NSMutableAttributedString alloc] initWithString:@"Selected: "];
        [lastCardSelected appendAttributedString:[self titleForCard:self.game.lastCardChosen]];
        self.lastCardChosenLabel.attributedText = lastCardSelected;
        
        [self.gameHistory addObject:lastCardSelected];
        
        // update the score, selected and status labels
        NSMutableAttributedString *matchUpdate = [[NSMutableAttributedString alloc] init];
        
        if (self.game.lastScore) { // did we gain or lose any points?
            
            // Create an attributed string from the most recently selected group of cards
            NSMutableAttributedString *selectedText = [[NSMutableAttributedString alloc] initWithString:@"Matching: "];
            [matchUpdate appendAttributedString:selectedText];
            for (Card *card in self.game.lastCardsChosenToMatch) {
                [matchUpdate appendAttributedString:[self titleForCard:card]];
            }
            
            // add on the score earned to the attributed string
            NSMutableAttributedString *scoreUpdate;
            if (self.game.lastScore > 0) {
                scoreUpdate = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"... Matched, %d points", self.game.lastScore]];
            } else if (self.game.lastScore < 0) {
                scoreUpdate = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"... No match, %d points", self.game.lastScore]];
            }
            
            [matchUpdate appendAttributedString:scoreUpdate];
            [self.gameHistory addObject:matchUpdate];
            
        } else {
            matchUpdate = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@""]];
        }
        
        self.statusLabel.attributedText = matchUpdate;

    } else {
        self.gameHistory = nil;
        self.statusLabel.attributedText = nil;
        self.scoreLabel.text = @"Score: 0";
        self.lastCardChosenLabel.attributedText = nil;
    }
    
    
}

-(NSAttributedString *)titleForCard:(Card *)card
{
    return nil;
}

-(UIImage *)backgroundImageForCard:(Card *)card;
{
    return nil;
}

@end
