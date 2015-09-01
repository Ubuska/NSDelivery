//
//  IMProductViewCell.m
//  Delivery
//
//  Created by Developer on 10.12.14.
//  Copyright (c) 2014 incodemobile. All rights reserved.
//

#import "IMProductViewCell.h"

@implementation IMProductViewCell

@synthesize name;
@synthesize photo;
@synthesize description;
@synthesize price;
@synthesize image;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
