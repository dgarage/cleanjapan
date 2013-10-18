//
//  RootViewController.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/2/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ParseStarterProjectAppDelegate.h"
#import "Annotation.h"
#import "DetailViewController.h"
#import "Reachability.h"
@interface RootViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UIButton *button;
    UIImage *image;
    //map
    IBOutlet MKMapView *mapView;
    CLLocationManager *locationManager;
    float photoLatitude;
    float photoLongitude;
    IBOutlet UIBarButtonItem *barButtonItem;
}
-(IBAction)showActionSheet;
//for debug
-(IBAction)showDebugView;
-(IBAction)check;
@end


