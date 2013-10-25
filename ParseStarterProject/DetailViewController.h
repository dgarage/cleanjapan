//
//  DetailViewController.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/10/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Annotation.h"
#import "CommentTableViewCell.h"
#import "PhotoViewController.h"
@interface DetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate>{
    IBOutlet UIScrollView *backgroundScrollView;
    IBOutlet UITableView *commentTableView;
    IBOutlet UITextView *commentTextView;
    IBOutlet UIButton *tableHeaderViewButton;
    IBOutlet UITextView *tableHeaderViewTextView;
    IBOutlet UILabel *tableHeaderViewUserNameLabel;
    IBOutlet UILabel *tableHeaderViewCreatedAtLabel;
    IBOutlet UIButton *commentButton;
}
- (IBAction)comment;
- (IBAction)tableHeaderViewButtonTapped;
@property (nonatomic, retain) Annotation *annotation;
@property (nonatomic, retain) NSMutableArray *commentObjectArray;

@end
