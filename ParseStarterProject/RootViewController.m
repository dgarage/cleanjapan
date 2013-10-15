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
#import "ParseGetDataViewController.h"
@interface RootViewController ()
@property (nonatomic, strong) NSMutableArray *allPosts;
@property (nonatomic, assign) BOOL mapPinsPlaced;
@end

@implementation RootViewController
@synthesize allPosts;
@synthesize mapPinsPlaced;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        allPosts = [[NSMutableArray alloc] initWithCapacity:10];
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
    
    SubmitViewController *submitViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"SubmitViewController"];
    [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [submitViewController setImage:image];
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary || picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        [assetslibrary assetForURL:[info objectForKey:UIImagePickerControllerReferenceURL]
                       resultBlock: ^(ALAsset *myasset) {
                           CLLocation *loc = ((CLLocation*)[myasset valueForProperty:ALAssetPropertyLocation]);
                           CLLocationCoordinate2D c = loc.coordinate;
                           photoLatitude   = c.latitude;
                           photoLongitude  = c.longitude;
                           NSLog(@"photoLibrary LON:%f LAT:%f", photoLatitude, photoLongitude);
                           PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:photoLatitude longitude:photoLongitude];
                           [submitViewController setGeoPoint:geoPoint];
                       }
                      failureBlock: ^(NSError *err) {
                      }];
    }else{
        photoLatitude = locationManager.location.coordinate.latitude;
        photoLongitude = locationManager.location.coordinate.longitude;
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:photoLatitude longitude:photoLongitude];
        NSLog(@"geoPoint LON:%f LAT:%f", geoPoint.latitude, geoPoint.longitude);
        [submitViewController setGeoPoint:geoPoint];
    }
    NSLog(@"push");
    [picker pushViewController:submitViewController animated:YES];
}

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    // Create a PFGeoPoint using the current location (to use in our query)
    if ([self.allPosts count] == 0)
    {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    PFGeoPoint *centerGeoPoint =
    [PFGeoPoint geoPointWithLatitude:mapView.centerCoordinate.latitude
                           longitude:mapView.centerCoordinate.longitude];
    MKMapPoint centerMapPoint = MKMapPointForCoordinate(mapView.centerCoordinate);
    MKMapRect mapRect = mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mapRect), MKMapRectGetMinY(mapRect));
    float searchDistanceKilometers = MKMetersBetweenMapPoints(centerMapPoint, eastMapPoint)/(double)1000.0;
    NSLog(@"searchDistance: %f", searchDistanceKilometers);
    [query whereKey:@"location"
               nearGeoPoint:centerGeoPoint
           withinKilometers:searchDistanceKilometers];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (error) {
            NSLog(@"Error in geo query!");
        }else{
            // 1. Find new posts (those that we did not already have)
            NSMutableArray *newPosts = [[NSMutableArray alloc] init];
            NSMutableArray *allNewPosts = [[NSMutableArray alloc] init];
            for (PFObject *object in objects) {
                Annotation *newPost = [[Annotation alloc] initWithPFObject:object];
                [allNewPosts addObject:newPost];
                BOOL found = NO;
                for (Annotation *currentPost in allPosts) {
					if ([newPost equalToPost:currentPost]) {
						found = YES;
					}
                    if (!found) {
                        [newPosts addObject:newPost];
                    }
				}
			}
            // newPosts now contains our new objects.
            
			// 2. Find posts in allPosts that didn't make the cut.
            NSMutableArray *postsToRemove = [[NSMutableArray alloc] initWithCapacity:kPAWWallPostsSearch];
			for (Annotation *currentPost in allPosts) {
				BOOL found = NO;
				// Use our object cache from the first loop to save some work.
				for (Annotation *allNewPost in allNewPosts) {
					if ([currentPost equalToPost:allNewPost]) {
						found = YES;
					}
				}
				if (!found) {
					[postsToRemove addObject:currentPost];
				}
			}
			// postsToRemove has objects that didn't come in with our new results.
            
            // 3. Configure our new posts; these are about to go onto the map.
			for (Annotation *newPost in newPosts) {
				CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:newPost.coordinate.latitude longitude:newPost.coordinate.longitude];
				// if this post is outside the filter distance, don't show the regular callout.
				CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
				[newPost setTitleAndSubtitleOutsideDistance:( distanceFromCurrent > nearbyDistance ? YES : NO )];
				// Animate all pins after the initial load:
				newPost.animatesDrop = mapPinsPlaced;
			}
            
            // 4. Remove the old posts and add the new posts
            
            
            NSLog(@"result count %d", objects.count);
            for (PFObject *object in objects) {
//                NSLog(@"retrieved related post: %@", result);
                PFGeoPoint *geoPoint = [object objectForKey:@"location"];
                [self dropPin:CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude) withTitle:@"testTitle" subtitle:@"testSubtitle"];
            }
        }
    }];
}

- (void)dropPin:(CLLocationCoordinate2D)coordinate2D withTitle:(NSString *)title subtitle:(NSString *)subtitle{
    UIImage *imageTest = [UIImage imageNamed:@"hero.jpg"];
    Annotation *annotation=[[Annotation alloc] initWithCoordinate:coordinate2D andTitle:title andSubtitle:subtitle andImage:imageTest];
    [mapView addAnnotation:annotation];
    [mapView setDelegate:self];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *const kAnnotationReuseIdentifier = @"CPAnnotationView";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationReuseIdentifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationReuseIdentifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        UIImage *img = [UIImage imageNamed:@"hero.jpg"];
        UIButton *calloutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [calloutButton setBackgroundImage:img forState:UIControlStateNormal];  // 画像をセットする
        [calloutButton addTarget:self action:@selector(calloutButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = calloutButton;
        annotationView.image = [self resize:[UIImage imageNamed:@"hero.jpg"] width:50 height:50];
    }
    return annotationView;
}

- (void)calloutButtonTapped{
    NSLog(@"calloutButtonTapped");
    DetailViewController *detailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

- (UIImage *)resize:(UIImage *)originalImage width:(float)width height:(float)height{
    CGSize resizedSize = CGSizeMake(width, height);
    UIGraphicsBeginImageContext(resizedSize);
    [originalImage drawInRect:CGRectMake(0, 0, resizedSize.width, resizedSize.height)];
    UIImage* resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

-(IBAction)check{
    NSLog(@"check");
    [self queryForAllPostsNearLocation:locationManager.location withNearbyDistance:100];
    NSLog(@"current map size:latitudeDelta%f longitudeDelta:/%f", mapView.region.span.latitudeDelta, mapView.region.span.longitudeDelta);
    
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

-(IBAction)showDebugView{
    ParseGetDataViewController *debugView = [[self storyboard] instantiateViewControllerWithIdentifier:@"debugView"];
    [self presentViewController:debugView animated:YES completion:nil];
}

@end
