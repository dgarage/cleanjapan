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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSLog(@"CommentTableViewCell initWithStyle");
        userIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:userIconImageView];
        
        userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        userNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        userNameLabel.numberOfLines = 0;
        [self.contentView addSubview:userNameLabel];
        
        commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        commentLabel.font = [UIFont systemFontOfSize:16.0f];
        commentLabel.numberOfLines = 0;
        [self.contentView addSubview:commentLabel];
        
        createdAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        createdAtLabel.font = [UIFont systemFontOfSize:14.0f];
        createdAtLabel.lineBreakMode = NSLineBreakByWordWrapping;
        createdAtLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:createdAtLabel];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if ( !(self = [super initWithCoder:aDecoder]) ) return nil;
    NSLog(@"CommentTableViewCell initWithCoder");
    userIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:userIconImageView];
    
    userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    userNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    userNameLabel.numberOfLines = 0;
    [self.contentView addSubview:userNameLabel];
    
    commentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    commentLabel.font = [UIFont systemFontOfSize:16.0f];
    commentLabel.numberOfLines = 0;
    [self.contentView addSubview:commentLabel];
    
    createdAtLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    createdAtLabel.font = [UIFont systemFontOfSize:14.0f];
    createdAtLabel.lineBreakMode = NSLineBreakByWordWrapping;
    createdAtLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:createdAtLabel];
    
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

- (void)setupCommentObject:(PFObject *)commentObject
{
    userIconImageView.image = [Identicon identiconWithString:[[commentObject objectForKey:@"user"] objectId] size:CGSizeMake(STUserIconSize, STUserIconSize)];
    //check the post was by anonymous or not
    if ([[commentObject objectForKey:@"user"] objectForKey:@"email"] == NULL) {
        //anonymous user's post
        userNameLabel.text = [@"Guest ID:" stringByAppendingString:[[commentObject objectForKey:@"user"] objectId]];
    }else{
        //not anonymous's post
        userNameLabel.text = [[commentObject objectForKey:@"user"] objectForKey:@"username"];
    }
    commentLabel.text = [commentObject objectForKey:@"comment"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *theDate = [dateFormatter stringFromDate:[commentObject createdAt]];
    createdAtLabel.text = theDate;
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
        userIconImageView.frame = userIconViewFrame;
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

+ (CGSize)sizeThatFits:(CGSize)size userIconViewFrame:(UIImageView *)userIconImageView userNameLabel:(UILabel*)userNameLabel commentLabel:(UILabel*)commentLabel createdAtLabel:(UILabel*)createdAtLabel withLayout:(BOOL)withLayout{
    
    CGRect userIconViewFrame;
    userIconViewFrame.origin.x = STMargin;
    userIconViewFrame.origin.y = STMargin;
    userIconViewFrame.size.width = STUserIconSize;
    userIconViewFrame.size.height = STUserIconSize;
    if (withLayout) {
        userIconImageView.frame = userIconViewFrame;
    }
    CGFloat minHeight = userIconViewFrame.origin.y + userIconViewFrame.size.height + STMargin;
    
    CGRect usernameLabelFrame;
    usernameLabelFrame.origin.x = userIconViewFrame.origin.x + userIconViewFrame.size.width + STMargin;
    usernameLabelFrame.origin.y = STMargin;
    usernameLabelFrame.size.width = size.width - usernameLabelFrame.origin.x - STMargin;
    usernameLabelFrame.size.height = size.height - usernameLabelFrame.origin.y;
    NSLog(@"delete me:%f", usernameLabelFrame.size.height);
    usernameLabelFrame.size = [userNameLabel sizeThatFits:usernameLabelFrame.size];
    NSLog(@"delete me:%f", usernameLabelFrame.size.height);
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
