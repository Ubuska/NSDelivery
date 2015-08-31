//
//  IMHeaderViewCell.m
//  Delivery
//
//  Created by Peter on 18/06/15.
//  Copyright (c) 2015 incodemobile. All rights reserved.
//

#import "IMHeaderViewCell.h"

@implementation IMHeaderViewCell

- (void) OnHeaderPress;
{
    [_Controller HeaderPress:_HeaderSection];
    
}

@end
