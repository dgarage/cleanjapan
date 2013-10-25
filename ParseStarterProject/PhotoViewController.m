//
//  PhotoViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/25/13.
//
//

#import "PhotoViewController.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController
@synthesize imageView;
@synthesize scrollView;
@synthesize object;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFFile *imageFile = [object objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            imageView.image  = image;
        }
    }];
    
    scrollView.contentSize = imageView.image.size;
    scrollView.delegate = self;
    //    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 100.0;
    imageView.center = scrollView.center;
}

// MARK: - UIScrollViewDelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return  imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)sv
{
    UIView* zoomView = [sv.delegate viewForZoomingInScrollView:sv];
    CGRect zvf = zoomView.frame;
    if(zvf.size.width < sv.bounds.size.width)
    {
        zvf.origin.x = (sv.bounds.size.width - zvf.size.width) / 2.0;
    }
    else
    {
        zvf.origin.x = 0.0;
    }
    if(zvf.size.height < sv.bounds.size.height)
    {
        zvf.origin.y = (sv.bounds.size.height - zvf.size.height) / 2.0;
    }
    else
    {
        zvf.origin.y = 0.0;
    }
    zoomView.frame = zvf;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
