//
//  ParseGetDataViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/9/13.
//
//

#import "ParseGetDataViewController.h"

@interface ParseGetDataViewController ()

@end

@implementation ParseGetDataViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction) debug {
    PFUser *user = [PFUser user];
    user.username = @"my name";
    user.password = @"my pass";
    user.email = @"email@example.com";
    
    // other fields can be set just like with PFObject
    user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

-(IBAction)login{
    NSLog(@"login");
    [PFUser logInWithUsernameInBackground:@"my name" password:@"my pass"
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"login OK");
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"login error");
                                        }
                                    }];
}


//
-(IBAction)retrieveData{
//    NSLog(@"retrieveData");
//    textView.text = @"";
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:
//                              @"latitude > 35 AND latitude < 36"];
//    PFQuery *query = [PFQuery queryWithClassName:@"TestObject" predicate:predicate];
//    
//    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
//        NSLog(@"result count %d", results.count);
//        //PFObject *lastResult = [results lastObject];
//        for (PFObject *result in results) {
//            NSLog(@"retrieved related post: %@", result);
//            PFObject *latitude = [result objectForKey:@"latitude"];
//            PFObject *longitude = [result objectForKey:@"longitude"];
//            NSLog(@"latitude: %@ / longitude:%@", latitude, longitude);
//            NSMutableString *str = [NSMutableString stringWithString:textView.text];
//            [str appendString:[NSString stringWithFormat:@"%@",result]];
//            textView.text = str;
//        }
//            // results will contain users with a hometown team with a winning record
//    }];
//    //NSArray *results = [query findObjects];
}

@end
