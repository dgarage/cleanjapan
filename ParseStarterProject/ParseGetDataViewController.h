//
//  ParseGetDataViewController.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/9/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface ParseGetDataViewController : UIViewController{
    IBOutlet UITextView *textView;
}
- (IBAction)retrieveData;
@end
