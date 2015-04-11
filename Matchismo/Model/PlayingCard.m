//
//  PlayingCard.m
//  Matchismo
//
//  Created by Alex Smith on 30/08/2014.
//  Copyright (c) 2014 Game House. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(int)match:(NSArray *)otherCards
{
    
    int score = 0;
    int matchCount = 0;
    NSMutableArray *allCards = [NSMutableArray arrayWithArray:otherCards];
    [allCards addObject:self];

    NSMutableArray *cardsToCheckAgainst = [NSMutableArray arrayWithArray:allCards];
    
    for (PlayingCard *currentCard in allCards) {
        
        [cardsToCheckAgainst removeObject:currentCard];
        
        for (PlayingCard *otherCard in cardsToCheckAgainst) {
            if (otherCard.rank == currentCard.rank) {
                score += 4;
                matchCount++;
            } else if ([otherCard.suit isEqualToString:currentCard.suit]) {
                score += 1;
                matchCount++;
            }
        }
        
    }
    
    return score * matchCount;
}


//override the superclass's getter but no need to redeclare the property (the declaration is inherited from the superclass)
-(NSString *)contents
{

    NSArray *rankStrings = [PlayingCard rankStrings];
    
    //return [NSString stringWithFormat:@"%d%@", self.rank, self.suit]; // stringWithFormat is a CLASS method that can be used in place of alloc/init.
    
    return [rankStrings[self.rank] stringByAppendingString:self.suit]; // rankStrings[self.rank] is an NSString object (the rankStrings array contains NSString objects). Again, "rankStrings[self.rank]" is replaced by the compiler with a normal message send like "[rankStrings objectAtIndex: self.rank]".
}

+(NSArray *)validSuits // class method on PlayingCard - CANNOT access instance variables as they represent per instance storage.
{
    return @[@"♣︎", @"♥︎", @"♦︎", @"♠︎"];
}


+(NSArray *)rankStrings // leaving this method private (not declared)
{
    
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"]; // "= @[" is replaced by the compiler with "= [NSArray alloc] initWithObjects...]". Rank 0 = "?", rank 1 = "A" and so on.
}

+(NSUInteger)maxRank
{
    return ( [[self rankStrings] count] - 1 );
}

-(void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) { // prevents the rank from being set to an improper value
        _rank = rank;
    }

}

@synthesize suit = _suit; // we HAVE to synthesize the property if we are overriding BOTH the setter and getter. The compiler will add this line for us if we only override 1 or none of the setter and getter. The instance variable is almost always a _ followed by the name of the property.

-(void)setSuit:(NSString *)suit
{
    // prevent people setting an invalid character for the suit
    if( [[PlayingCard validSuits] containsObject: suit] ) {
        _suit = suit; // the instance variables should ONLY ever be accessed directly in a setter, getter or initialiser
    }
}

-(NSString *)suit // getter for suit property
{
    return _suit ? _suit : @"?"; // has suit been set? only return a suit that has been set, otherwise return "?"
}

@end
