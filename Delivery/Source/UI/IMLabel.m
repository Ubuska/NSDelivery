//
//  IMCustomFont.m
//  Delivery
//
//  Created by Developer on 23.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//
#import "IMFont.h"
#import "IMLabel.h"
#import "IMAppDelegate.h"

@implementation IMLabel

- (void)prepareAppearance
{
    // Абстрактный метод для переопределения наследниками
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self prepareAppearance];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self prepareAppearance];
}



- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder: decoder])
    {
        [self setFont: [UIFont fontWithName: @"Lobster" size: self.font.pointSize]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

@implementation IMHeader : IMLabel

- (void)prepareAppearance { self.font = [IMFont Font_Header]; }

@end

@implementation IMText : IMLabel

- (void)prepareAppearance { self.font = [IMFont Font_RegularText]; }

@end

@implementation IMSectionHeader : IMLabel;

- (void)prepareAppearance
{
    {
        
        self.font = [IMFont Font_SectionHeader];
        
    }
    
}

@end
