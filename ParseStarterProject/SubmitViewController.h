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
    IBOutlet UIImageView *imageView;
    IBOutlet UIButton *button;
    IBOutlet UITextView *textView;
    PFInstallation *installation;
}
@property(nonatomic, retain)UIImage *image;
@property (nonatomic, strong)PFGeoPoint *geoPoint;

@end
