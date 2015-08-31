//
//  IMButtonEffect.m
//  Delivery
//
//  Created by Developer on 16.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMButtonEffect.h"

@interface IMButtonEffect()

@property(nonatomic) CGAffineTransform originalTransform;
@property(nonatomic) CGAffineTransform pressedTransform;
@property(nonatomic) CGAffineTransform middleTransform;

@end

@implementation IMButtonEffect

@synthesize buttonSizeWhenPressed = _buttonSizeWhenPressed;
@synthesize originalTransform = _originalTransform;
@synthesize pressedTransform = _pressedTransform;
@synthesize middleTransform = _middleTransform;

-(id)init
{
    self = [super init];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.adjustsImageWhenHighlighted = NO;
    _originalTransform = self.transform;
    _buttonSizeWhenPressed = 0.9f;
}

-(void)setHighlighted:(BOOL)highlighted
{
    //We double check that the state has actually changed before we start the effect animations
    if(self.isHighlighted != highlighted)
    {
        if(highlighted)
        {
            [self doPushEffect];
        }
        else
        {
            [self doReleaseEffect];
        }
    }
    
    [super setHighlighted:highlighted];
}

-(void)doPushEffect
{
    [self animateThreeTransformationsOne:_pressedTransform two:_middleTransform three:_pressedTransform];
}

-(void)doReleaseEffect
{
    [self animateThreeTransformationsOne:_originalTransform two:_middleTransform three:_originalTransform];
}

-(void)animateThreeTransformationsOne:(CGAffineTransform)transform1 two:(CGAffineTransform)transform2 three:(CGAffineTransform)transform3
{
    [UIView animateKeyframesWithDuration:0.1 delay:0 options:0 animations:^(void)
    {
        self.transform = transform1;
    }
                              completion:^(BOOL finished)
    {
        [UIView animateKeyframesWithDuration:0.1 delay:0 options:0 animations:^(void)
        {
            self.transform = transform2;
        }
     completion:^(BOOL finished)
        {
            [UIView animateKeyframesWithDuration:0.1 delay:0 options:0 animations:^(void)
            {
                self.transform = transform3;
            } completion:nil];
        }];
    }];
}

-(void)setButtonSizeWhenPressed:(float)buttonSizeWhenPressed
{
    _buttonSizeWhenPressed = buttonSizeWhenPressed;
    _pressedTransform = CGAffineTransformScale(_originalTransform, _buttonSizeWhenPressed, _buttonSizeWhenPressed);
    _middleTransform = CGAffineTransformScale(_originalTransform, 1.0f - (1.0f-_buttonSizeWhenPressed)/2, 1.0f - (1.0f-_buttonSizeWhenPressed)/2);
}

@end

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

