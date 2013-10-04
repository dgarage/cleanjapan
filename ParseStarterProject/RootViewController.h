//
//  RootViewController.h
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/2/13.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface RootViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    IBOutlet UILabel *testLabel;
    IBOutlet UIButton *testButton;
    IBOutlet UITextField *testTextField;
    //map
    IBOutlet MKMapView *mapView;
    CLLocationManager *locationManager;
}

-(IBAction)bentatsu;
@end
