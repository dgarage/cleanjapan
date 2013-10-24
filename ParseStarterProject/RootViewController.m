//
//  RootViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/2/13.
//
//

#define ALERT_CONNECT_ERROR 1
#define ALERT_ANONYMOUS_ERROR 2

#import "RootViewController.h"
#import <Parse/Parse.h>
#import "SubmitViewController.h"
#import "CommentViewController.h"
#import "LogInViewController.h"
#import "SignUpViewController.h"

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
    self.title = @"Clean Japan";
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

    allPosts = [[NSMutableArray alloc] init];
    
    //login
    if ([self reachable]) {
        //on line user
        [self automaticallyLogin];
    }else{
        //off line
        //message
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AletTest2" message:@"Please connect the internet." delegate:self cancelButtonTitle:@"OK, Retry" otherButtonTitles:nil];
        alertView.tag = ALERT_CONNECT_ERROR;
        [alertView show];
    }
    //keychain reset
//    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"cleanjapan" accessGroup:nil];
//    [keychainItem resetKeychainItem];
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

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case ALERT_ANONYMOUS_ERROR:
            switch (buttonIndex) {
                case 0:
                    //１番目のボタンが押されたときの処理を記述する
                    NSLog(@"ALERT_ANONYMOUS_ERROR");
                    [self automaticallyLogin];
                    break;
                case 1:
                    //２番目のボタンが押されたときの処理を記述する
                    break;
            }
            break;
        case ALERT_CONNECT_ERROR:
            switch (buttonIndex) {
                case 0:
                    //１番目のボタンが押されたときの処理を記述する
                    NSLog(@"ALERT_CONNECT_ERROR");
                    break;
                case 1:
                    //２番目のボタンが押されたときの処理を記述する
                    [self automaticallyLogin];
                    break;
            }
            break;
        default:
            break;
    }
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

- (void)queryForAllPostsNearLocation:(CLLocation *)currentLocation {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
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
    [query includeKey:kPAWParseUserKey];
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
				}
                if (!found) {
                    [newPosts addObject:newPost];
                }
			}
            // newPosts now contains our new objects.
            
			// 2. Find posts in allPosts that didn't make the cut.
            NSMutableArray *postsToRemove = [[NSMutableArray alloc] init];
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
                // Animate all pins after the initial load:
				newPost.animatesDrop = mapPinsPlaced;
			}
            
            // 4. Remove the old posts and add the new posts
            // At this point, newAllPosts contains a new list of post objects.
			// We should add everything in newPosts to the map, remove everything in postsToRemove,
			// and add newPosts to allPosts.
			[mapView removeAnnotations:postsToRemove];
			[mapView addAnnotations:newPosts];
			[mapView setDelegate:self];
            [allPosts addObjectsFromArray:newPosts];
			[allPosts removeObjectsInArray:postsToRemove];
            
			self.mapPinsPlaced = YES;
            
            NSLog(@"pin num is %d", allPosts.count);
            
//            NSLog(@"result count %d", objects.count);
//            for (PFObject *object in objects) {
////                NSLog(@"retrieved related post: %@", result);
//                PFGeoPoint *geoPoint = [object objectForKey:@"location"];
//                [self dropPin:CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude) withTitle:@"testTitle" subtitle:@"testSubtitle"];
//            }
        }
    }];
}

//- (void)dropPin:(CLLocationCoordinate2D)coordinate2D withTitle:(NSString *)title subtitle:(NSString *)subtitle{
//    UIImage *imageTest = [UIImage imageNamed:@"hero.jpg"];
//    Annotation *annotation=[[Annotation alloc] initWithCoordinate:coordinate2D andTitle:title andSubtitle:subtitle andImage:imageTest];
//    [mapView addAnnotation:annotation];
//    [mapView setDelegate:self];
//}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *const kAnnotationReuseIdentifier = @"CPAnnotationView";
    
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationReuseIdentifier];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationReuseIdentifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        //ピンのアイコンと、calloutのボタンのデザインをデフォルトを使用するためコメントアウト
//        UIImage *img = [UIImage imageNamed:@"hero.jpg"];
//
//        UIButton *calloutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [calloutButton setBackgroundImage:img forState:UIControlStateNormal];  // 画像をセットする
//        annotationView.rightCalloutAccessoryView = calloutButton;
//        annotationView.image = [self resize:[UIImage imageNamed:@"hero.jpg"] width:50 height:50];// pinをデフォルトにするために、コメントアウト
    }
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"calloutButtonTapped");
    Annotation *annotation = (Annotation*)view.annotation;
    NSLog(@"annotation comment:%f", annotation.coordinate.latitude);
    NSLog(@"annotation objectID: %@", [annotation.object objectId]);
    DetailViewController *detailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
    [detailViewController setAnnotation:(annotation)];
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
    NSLog(@"reachable: %d", [self reachable]);
    [self queryForAllPostsNearLocation:locationManager.location];
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
    CommentViewController *commentViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"CommentViewController"];
    [self.navigationController pushViewController:commentViewController animated:YES];
}

//below is for test
-(IBAction)login{

//    [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
//        if (error) {
//            NSLog(@"Anonymous login failed.");
//        } else {
//            NSLog(@"Anonymous user logged in.");
//        }
//    }];
    
    LogInViewController *logInViewController = [[LogInViewController alloc] init];
    logInViewController.delegate = logInViewController;
    logInViewController.facebookPermissions = @[@"friends_about_me"];
    logInViewController.fields = PFLogInFieldsUsernameAndPassword | PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsSignUpButton | PFLogInFieldsDismissButton;
    
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    signUpViewController.delegate = signUpViewController;
    signUpViewController.fields = PFSignUpFieldsDefault | PFSignUpFieldsAdditional;
    logInViewController.signUpController = signUpViewController;
    
    [self presentViewController:logInViewController animated:YES completion:nil];
}

-(void)automaticallyLogin{
    KeychainItemWrapper *keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"cleanjapan" accessGroup:nil];
    [PFUser logInWithUsernameInBackground:[keychainItem objectForKey:(__bridge id)(kSecValueData)] password:[keychainItem objectForKey:(__bridge id)(kSecAttrAccount)]
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"login success!");
                                            NSLog(@"login User: %@", [keychainItem objectForKey:(__bridge id)(kSecValueData)]);
                                            NSLog(@"login Pass: %@", [keychainItem objectForKey:(__bridge id)(kSecAttrAccount)]);
                                            barButtonItem.title = [keychainItem objectForKey:(__bridge id)(kSecValueData)];
                                        } else {
                                            // The login failed. Check error to see why.
                                            [PFAnonymousUtils logInWithBlock:^(PFUser *user, NSError *error) {
                                                if (error) {
                                                    NSLog(@"Anonymous login failed.");
                                                    //message
                                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AlertTest1" message:@"Please Retry." delegate:self cancelButtonTitle:@"Retry" otherButtonTitles:nil];
                                                    alertView.tag = ALERT_ANONYMOUS_ERROR;
                                                    [alertView show];
                                                } else {
                                                    NSLog(@"Anonymous user logged in.");
                                                    barButtonItem.title = @"Guest";
                                                }
                                            }];
                                        }
                                    }];
}

-(BOOL)reachable {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if(networkStatus == NotReachable) {
        return NO;
    }
    return YES;
}

@end
