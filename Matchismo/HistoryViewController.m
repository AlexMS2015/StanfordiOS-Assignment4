//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Alex Smith on 9/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HistoryViewController

-(NSArray *)gameHistory
{
    if (!_gameHistory) {
        _gameHistory = [NSMutableArray array];
    }
    
    return _gameHistory;
}

-(void)viewDidAppear:(BOOL)animated
{
    NSMutableAttributedString *gameHistoryString = [[NSMutableAttributedString alloc] init];
    
    for (NSMutableAttributedString *attString in self.gameHistory) {
        [gameHistoryString appendAttributedString:attString];
        NSAttributedString *newLine = [[NSAttributedString alloc] initWithString:@"\n\n"];
        [gameHistoryString appendAttributedString:newLine];
    }
    
    self.textView.attributedText = gameHistoryString;
}

@end
