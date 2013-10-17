//
//  SignUpViewController.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/17/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SignUpViewController : UIViewController<UITableViewDelegate, UITextFieldDelegate, UITableViewDataSource>{
    IBOutlet UITableView *tableView;
}

@end
