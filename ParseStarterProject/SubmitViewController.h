//
//  SubmitViewController.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/8/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SubmitViewController : UIViewController{
    UIImageView *imageView;
    UIButton *button;
    UITextView *textView;
    PFInstallation *installation;
    UIBarButtonItem *commentBarButtonItem;
    UIScrollView *backgroundScrollView;
}
@property(nonatomic, retain)UIImage *image;
@property (nonatomic, strong)PFGeoPoint *geoPoint;

@end
