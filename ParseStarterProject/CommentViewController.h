//
//  CommentViewController.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/22/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Annotation.h"
@interface CommentViewController : UITableViewController{
    IBOutlet UITextField *textField;
}
@property (nonatomic, retain) NSMutableArray *commentArray;

@end
