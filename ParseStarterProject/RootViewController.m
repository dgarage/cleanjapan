//
//  RootViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/2/13.
//
//

#import "RootViewController.h"
#import <Parse/Parse.h>
@interface RootViewController ()

@end

@implementation RootViewController

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
    //map
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = kCLHeadingFilterNone;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    mapView.showsUserLocation = YES;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05f, 0.05f);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0.0f, 0.0f);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [mapView setRegion:region animated:NO];
}

//map----------------------------------------------------
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"NEW LOCATION!");
    MKCoordinateRegion  region = mapView.region;
    region.center.latitude = newLocation.coordinate.latitude;
    region.center.longitude = newLocation.coordinate.longitude;
    region.span.latitudeDelta = mapView.region.span.latitudeDelta;
    region.span.longitudeDelta = mapView.region.span.longitudeDelta;
    NSLog(@"Delta LAT:%f LON :%f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
    
    [mapView setRegion:region animated:YES];
    [mapView setCenterCoordinate:newLocation.coordinate animated:YES];
}

- (IBAction)bentatsu{
    CLLocation *location = [locationManager location];
    NSLog(@"LAT:%f LON:%f", location.coordinate.latitude, location.coordinate.longitude);
    UIImage *testImg= [UIImage imageNamed:@"hero.jpg"];
    //UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(testImg, 0.05f);
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:testLabel.text forKey:@"foo"];
    [testObject setObject:imageFile forKey:@"img"];
    [testObject setObject:testTextField.text forKey:@"comment"];
    [testObject setObject:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"latitude"];
    [testObject setObject:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"longitude"];
    [testObject save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
