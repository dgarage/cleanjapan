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
    UIScrollView *backgroundScrollView;
    UITableView *commentTableView;
    UITextView *commentTextView;
    UIButton *tableHeaderViewButton;
    UITextView *tableHeaderViewTextView;
    UILabel *tableHeaderViewUserNameLabel;
    UILabel *tableHeaderViewCreatedAtLabel;
    UIButton *commentButton;
    CommentTableViewCell *getHeightCell;
}
- (IBAction)comment;
- (IBAction)tableHeaderViewButtonTapped;



@property (nonatomic, retain) Annotation *annotation;
@property (nonatomic, retain) NSMutableArray *commentObjectArray;

@end
