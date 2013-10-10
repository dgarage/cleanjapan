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

-(IBAction)retrieveData{
    NSLog(@"retrieveData");
    textView.text = @"";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"latitude > 35 AND latitude < 36"];
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject" predicate:predicate];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        NSLog(@"result count %d", results.count);
        //PFObject *lastResult = [results lastObject];
        for (PFObject *result in results) {
            NSLog(@"retrieved related post: %@", result);
            PFObject *latitude = [result objectForKey:@"latitude"];
            PFObject *longitude = [result objectForKey:@"longitude"];
            NSLog(@"latitude: %@ / longitude:%@", latitude, longitude);
            NSMutableString *str = [NSMutableString stringWithString:textView.text];
            [str appendString:[NSString stringWithFormat:@"%@",result]];
            textView.text = str;
        }
            // results will contain users with a hometown team with a winning record
    }];
    //NSArray *results = [query findObjects];
}

@end
