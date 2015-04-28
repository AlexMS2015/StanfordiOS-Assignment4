//
//  CardPanBehaviour.m
//  Assignment 4
//
//  Created by Alex Smith on 28/04/2015.
//  Copyright (c) 2015 Game House. All rights reserved.
//

#import "CardPanBehaviour.h"

@interface CardPanBehaviour ()

@property (nonatomic, strong) UIAttachmentBehavior *attachment;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIDynamicItemBehavior *animationOptions;

@end

@implementation CardPanBehaviour

-(UIAttachmentBehavior *)attachment
{
    if (!_attachment) {
        _attachment = [[UIAttachmentBehavior alloc] init];
        
    }
    
    return _attachment;
}

@end
