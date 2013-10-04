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
    IBOutlet UIButton *testButton;
    IBOutlet UITextField *testTextField;
    UIImage *buttonImage;
    IBOutlet UIButton *button;
    //map
    IBOutlet MKMapView *mapView;
    CLLocationManager *locationManager;
}
-(IBAction)addImage;
-(IBAction)bentatsu;
@end
