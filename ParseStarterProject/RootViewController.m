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
//    NSLog(@"NEW LOCATION!");
    MKCoordinateRegion  region = mapView.region;
    region.center.latitude = newLocation.coordinate.latitude;
    region.center.longitude = newLocation.coordinate.longitude;
    region.span.latitudeDelta = mapView.region.span.latitudeDelta;
    region.span.longitudeDelta = mapView.region.span.longitudeDelta;
//    NSLog(@"Delta LAT:%f LON :%f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
    [mapView setRegion:region animated:YES];
    [mapView setCenterCoordinate:newLocation.coordinate animated:YES];
}

- (IBAction)bentatsu{
    //image picker
    [self showCameraSheet];
}

- (IBAction)showCameraSheet
{
    // アクションシートを作る
    UIActionSheet*  sheet;
    sheet = [[UIActionSheet alloc]
             initWithTitle:@"Select Soruce Type"
             delegate:self
             cancelButtonTitle:@"Cancel"
             destructiveButtonTitle:nil
             otherButtonTitles:@"Photo Library", @"Camera", @"Saved Photos", nil];
    // アクションシートを表示する
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet*)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex{
    // ボタンインデックスをチェックする
    NSLog(@"buttonIndex:%d", buttonIndex);
    if (buttonIndex >= 3) {
        return;
    }
    // ソースタイプを決定する
    UIImagePickerControllerSourceType   sourceType = 0;
    switch (buttonIndex) {
        case 0: {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        }
        case 1: {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
        case 2: {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            break;
        }
    }
    // 使用可能かどうかチェックする
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        return;
    }
    NSLog(@"image picker---------------------");
    UIImagePickerController *imagePicker;
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
//    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker
        didFinishPickingImage:(UIImage*)image
                  editingInfo:(NSDictionary*)editingInfo
{
    // イメージピッカーを隠す
    [self dismissViewControllerAnimated:YES completion:nil];
    //post
    NSLog(@"posting data to perse.com.....");
    CLLocation *location = [locationManager location];
    //    NSLog(@"LAT:%f LON:%f", location.coordinate.latitude, location.coordinate.longitude);
    //UIGraphicsEndImageContext();
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0f);//0が最高圧縮, 1が最低圧縮
    
    PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:testLabel.text forKey:@"foo"];
    [testObject setObject:imageFile forKey:@"img"];
    [testObject setObject:testTextField.text forKey:@"comment"];
    [testObject setObject:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"latitude"];
    [testObject setObject:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"longitude"];
    [testObject save];
    NSLog(@"done!");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    NSLog(@"check-10");
    // イメージピッカーを隠す
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"check-20");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
