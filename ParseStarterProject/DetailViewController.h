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
@interface DetailViewController : UIViewController{
    IBOutlet UITextView *textView;
    IBOutlet UIImageView *imageView;
}
@property (nonatomic, retain) Annotation *annotation;

@end
