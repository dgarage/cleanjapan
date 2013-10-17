//
//  SubmitViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/8/13.
//
//

#import "SubmitViewController.h"

@interface SubmitViewController ()
- (void)textInputChanged:(NSNotification *)note;
@end

@implementation SubmitViewController
@synthesize image;
@synthesize geoPoint;
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
    [textView becomeFirstResponder];
    installation = [PFInstallation currentInstallation];
    [installation saveInBackground];
    button.enabled = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextViewTextDidChangeNotification object:textView];
}


- (IBAction)submit{
    //post
    NSLog(@"posting data to perse.com.....");
    //    NSLog(@"LAT:%f LON:%f", location.coordinate.latitude, location.coordinate.longitude);
    //UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0f);//0が最高圧縮, 1が最低圧縮
    PFFile *imageFile = [PFFile fileWithName:@"image.jpg" data:imageData];
    PFObject *post = [PFObject objectWithClassName:@"Post"];
    [post setObject:imageFile forKey:@"image"];
    [post setObject:textView.text forKey:@"title"];
    [post setObject:[NSNumber numberWithDouble:geoPoint.latitude] forKey:@"latitude"];
    [post setObject:[NSNumber numberWithDouble:geoPoint.longitude] forKey:@"longitude"];
    [post setObject:[PFGeoPoint geoPointWithLatitude:geoPoint.latitude longitude:geoPoint.longitude] forKey:@"location"];
    [post setObject:[NSString stringWithString:installation.timeZone] forKey:@"timezone"];
//    NSUUID *uniqueId = [[NSUUID alloc] init];
//    NSLog(@"id %@", [uniqueId UUIDString]);
//    [post setObject:[NSString stringWithFormat:@"%@", [uniqueId UUIDString]] forKey:@"uuid"];
    UIDevice *device = [[UIDevice alloc] init];
    NSLog(@"%@", [device.identifierForVendor UUIDString]);
    [post setObject:[NSString stringWithFormat:@"%@", [device.identifierForVendor UUIDString]] forKey:@"identifierForVendor"];
    
    
    ///test
    PFUser *user = [PFUser currentUser];
    [post setObject:user forKey:@"user"];
    //test
    
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"upload done!");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldEnableDoneButton {
	BOOL enableDoneButton = NO;
	if (textView.text != nil &&
		textView.text.length > 0) {
		enableDoneButton = YES;
	}
	return enableDoneButton;
}

- (void)textInputChanged:(NSNotification *)note {
    button.enabled = [self shouldEnableDoneButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


