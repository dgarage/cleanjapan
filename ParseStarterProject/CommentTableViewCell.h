//
//  CommentTableViewCell.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/25/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@end
