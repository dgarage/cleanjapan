//
//  DetailViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/10/13.
//
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize annotation;
@synthesize commentArray;

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
    NSLog(@"annotation objectID: %@", [annotation.object objectId]);
    textView.text = [NSString stringWithFormat:@"%@", [annotation.object objectForKey:@"title"]];
    PFFile *imageFile = [annotation.object objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            imageView.image = image;
        }
    }];
//    UIImage *image = [UIImage imageWithData:[annotation.object objectForKey:@"image"]];
    //comment
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"postObjectId" equalTo:[annotation.object objectId]];
    commentArray = [NSMutableArray array];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                [commentArray addObject:[object objectForKey:@"comment"]];
            }
            [commentTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [commentArray objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentArray.count;
}

-(IBAction)comment{
    NSLog(@"comment: %@", commentTextView.text);
    PFObject *comment = [PFObject objectWithClassName:@"Comment"];
    [comment setObject:commentTextView.text forKey:@"comment"];
    PFUser *user = [PFUser currentUser];
    [comment setObject:user forKey:@"user"];
    [comment setObject:[annotation.object objectId] forKey:@"postObjectId"];
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"comment upload done!");
        }
    }];
}

-(void)dismissKeyboard {
    [commentTextView resignFirstResponder];
}

@end
