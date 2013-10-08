//
//  SubmitViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/8/13.
//
//

#import "SubmitViewController.h"

@interface SubmitViewController ()

@end

@implementation SubmitViewController
@synthesize image;
@synthesize gps;
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
	// Do any additional setup after loading the view.
    imageView.image = image;
    [textField becomeFirstResponder];
    installation = [PFInstallation currentInstallation];
    [installation saveInBackground];
}


- (IBAction)submit{
    //post
    NSLog(@"posting data to perse.com.....");
    //    NSLog(@"LAT:%f LON:%f", location.coordinate.latitude, location.coordinate.longitude);
    //UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0f);//0が最高圧縮, 1が最低圧縮
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:imageFile forKey:@"image"];
    [testObject setObject:textField.text forKey:@"comment"];
    [testObject setObject:[NSString stringWithFormat:@"%f", gps.x] forKey:@"latitude"];
    [testObject setObject:[NSString stringWithFormat:@"%f", gps.y] forKey:@"longitude"];
    [testObject setObject:[NSString stringWithString:installation.timeZone] forKey:@"timezone"];
    [testObject save];
    NSLog(@"upload done!");
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


