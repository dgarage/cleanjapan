//
//  CommentTableViewCell.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/25/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface CommentTableViewCell : UITableViewCell{
//    __strong UIImageView *_userIconView;
    UILabel *userNameLabel;
    UILabel *commentLabel;
    UILabel *createdAtLabel;
}
- (void)setupCommentObject:(PFObject *)commentObject;
@end
