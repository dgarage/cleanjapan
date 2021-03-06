//
//  CommentTableViewCell.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/25/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Identicon.h"
@interface CommentTableViewCell : UITableViewCell{
    UIImageView *userIconImageView;
    UILabel *userNameLabel;
    UILabel *commentLabel;
    UILabel *createdAtLabel;
}
- (void)setupCommentObject:(PFObject *)commentObject;
+ (CGSize)sizeThatFits:(CGSize)size userIconViewFrame:(UIImageView *)userIconImageView userNameLabel:(UILabel*)userNameLabel commentLabel:(UILabel*)commentLabel createdAtLabel:(UILabel*)createdAtLabel withLayout:(BOOL)withLayout;
@end
