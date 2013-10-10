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
    [textField becomeFirstResponder];
    installation = [PFInstallation currentInstallation];
    [installation saveInBackground];
    button.enabled = NO;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputChanged:) name:UITextFieldTextDidChangeNotification object:textField];
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
    [testObject setObject:[NSNumber numberWithDouble:geoPoint.latitude] forKey:@"latitude"];
    [testObject setObject:[NSNumber numberWithDouble:geoPoint.longitude] forKey:@"longitude"];
    [testObject setObject:[PFGeoPoint geoPointWithLatitude:geoPoint.latitude longitude:geoPoint.longitude] forKey:@"location"];
    [testObject setObject:[NSString stringWithString:installation.timeZone] forKey:@"timezone"];
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"upload done!");
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldEnableDoneButton {
	BOOL enableDoneButton = NO;
	if (textField.text != nil &&
		textField.text.length > 0) {
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


