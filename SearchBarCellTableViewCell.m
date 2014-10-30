//
//  SearchBarCellTableViewCell.m
//  CoreDataTest
//
//  Created by Ge-Yunsheng on 2014/10/29.
//  Copyright (c) 2014年 geys. All rights reserved.
//

#import "SearchBarCellTableViewCell.h"

@implementation SearchBarCellTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
