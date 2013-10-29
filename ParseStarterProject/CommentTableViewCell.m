//
//  CommentTableViewCell.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/25/13.
//
//
#define STMargin 8
#define STUserIconSize 48
#define STMaxCellHeight 2000

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell
@synthesize commentLabel;
@synthesize createdAtLabel;
@synthesize userNameLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"layoutSubviews");
    CGRect bounds = self.bounds;
    [self sizeThatFits:bounds.size withLayout:YES];
}


/**
 * Override UIView method
 */
- (CGSize)sizeThatFits:(CGSize)size
{
    return [self sizeThatFits:size withLayout:NO];
}

/**
 * @param size Bounds size
 * @param withLayout YES if set frame of subviews.
 */
- (CGSize)sizeThatFits:(CGSize)size withLayout:(BOOL)withLayout{
    
    CGRect userIconViewFrame;
    userIconViewFrame.origin.x = STMargin;
    userIconViewFrame.origin.y = STMargin;
    userIconViewFrame.size.width = STUserIconSize;
    userIconViewFrame.size.height = STUserIconSize;
    if (withLayout) {
//        _userIconView.frame = userIconViewFrame;
    }
    CGFloat minHeight = userIconViewFrame.origin.y + userIconViewFrame.size.height + STMargin;
    
    CGRect usernameLabelFrame;
    usernameLabelFrame.origin.x = userIconViewFrame.origin.x + userIconViewFrame.size.width + STMargin;
    usernameLabelFrame.origin.y = STMargin;
    usernameLabelFrame.size.width = size.width - usernameLabelFrame.origin.x - STMargin;
    usernameLabelFrame.size.height = size.height - usernameLabelFrame.origin.y;
    usernameLabelFrame.size = [userNameLabel sizeThatFits:usernameLabelFrame.size];
    if (withLayout) {
        userNameLabel.frame = usernameLabelFrame;
    }
    
    CGRect statusLabelFrame;
    statusLabelFrame.origin.x = usernameLabelFrame.origin.x;
    statusLabelFrame.origin.y = usernameLabelFrame.origin.y + usernameLabelFrame.size.height;
    statusLabelFrame.size.width = size.width - statusLabelFrame.origin.x - STMargin;
    statusLabelFrame.size.height = size.height - statusLabelFrame.origin.y;
    statusLabelFrame.size = [commentLabel sizeThatFits:statusLabelFrame.size];
    if (withLayout) {
        commentLabel.frame = statusLabelFrame;
    }
    
    CGRect createdAtLabelFrame;
    createdAtLabelFrame.origin.x = statusLabelFrame.origin.x;
    createdAtLabelFrame.origin.y = statusLabelFrame.origin.y + statusLabelFrame.size.height;
    createdAtLabelFrame.size.width = size.width - createdAtLabelFrame.origin.x  - STMargin;
    createdAtLabelFrame.size.height = size.height - createdAtLabelFrame.origin.y;
    createdAtLabelFrame.size = [createdAtLabel sizeThatFits:createdAtLabelFrame.size];
    if (withLayout) {
        createdAtLabel.frame = createdAtLabelFrame;
    }
    
    size.height = createdAtLabelFrame.origin.y + createdAtLabelFrame.size.height + STMargin;
    if (size.height < minHeight) {
        size.height = minHeight;
    }
    return size;
}

@end
