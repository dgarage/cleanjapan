//
//  PhotoViewController.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/25/13.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface PhotoViewController : UIViewController<UIScrollViewDelegate>{

}

@property PFObject *object;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
