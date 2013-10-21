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
@interface DetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITextView *textView;
    IBOutlet UIImageView *imageView;
    IBOutlet UITableView *commentTableView;
    IBOutlet UITextView *commentTextView;
}
- (IBAction)comment;
@property (nonatomic, retain) Annotation *annotation;
@property (nonatomic, retain) NSMutableArray *commentArray;

@end
