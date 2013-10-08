//
//  RootViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/2/13.
//
//

#import "RootViewController.h"
#import <Parse/Parse.h>
#import "SubmitViewController.h"
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
    [mapView setRegion:region animated:YES];
    [mapView setCenterCoordinate:newLocation.coordinate animated:YES];
}


- (void)showActionSheet
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //GPS
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary || picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        [assetslibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
                       resultBlock: ^(ALAsset *myasset) {
                           CLLocation *loc = ((CLLocation*)[myasset valueForProperty:ALAssetPropertyLocation]);
                           CLLocationCoordinate2D c = loc.coordinate;
                           photoLatitude   = c.latitude;
                           photoLongitude  = c.longitude;
                           NSLog(@"photoLibrary LON:%f LAT:%f", photoLatitude, photoLongitude);
                       }
                      failureBlock: ^(NSError *err) {
                      }];
    }else{
        photoLatitude = locationManager.location.coordinate.latitude;
        photoLongitude = locationManager.location.coordinate.longitude;
    }
    [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    SubmitViewController *submitViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SubmitViewController"];
    [submitViewController setImage:image];
    [submitViewController setGps:CGPointMake(photoLatitude, photoLongitude)];
    NSLog(@"push");
    [picker pushViewController:submitViewController animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
    // イメージピッカーを隠す
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
