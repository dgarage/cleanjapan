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
@synthesize commentObjectArray;

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
    tableHeaderViewTextView.text = [NSString stringWithFormat:@"%@", [annotation.object objectForKey:@"title"]];
    PFFile *imageFile = [annotation.object objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            [tableHeaderViewButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
    tableHeaderViewUserNameLabel.text = [[annotation.object objectForKey:@"user"] objectForKey:@"username"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *date = [annotation.object createdAt];
    NSString *theDate = [dateFormatter stringFromDate:date];
    tableHeaderViewCreatedAtLabel.text = theDate;
//    UIImage *image = [UIImage imageWithData:[annotation.object objectForKey:@"image"]];
    //comment
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    [self retrieveComment];
    commentTextView.delegate = self;
    commentButton.enabled = false;
}

- (void)viewDidLayoutSubviews{
//    [scrollView setContentSize:scrollView.frame.size];
    [backgroundScrollView setContentSize:self.view.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (nil == cell){
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //user name
    cell.userNameLabel.text =[[[commentObjectArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:kPAWParseUsernameKey];
//    NSLog(@"%@", [[commentObjectArray objectAtIndex:indexPath.row] objectForKey:@"user"]);
    //comment
    cell.commentLabel.text = [[commentObjectArray objectAtIndex:indexPath.row] objectForKey:@"comment"];
//    cell.createdAtLabel.text =
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *date = [[commentObjectArray objectAtIndex:indexPath.row] createdAt];
    NSString *theDate = [dateFormatter stringFromDate:date];
    cell.createdAtLabel.text = theDate;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return commentObjectArray.count;
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
            [commentTextView setText:@""];
            [self retrieveComment];
        }
    }];
}

- (void)retrieveComment{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"postObjectId" equalTo:[annotation.object objectId]];
    [query includeKey:kPAWParseUserKey];
    commentObjectArray = [NSMutableArray array];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            [commentObjectArray addObjectsFromArray:objects];
            [commentTableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)dismissKeyboard {
    [commentTextView resignFirstResponder];
}

//keyboard

- (void)keyboardWillShow:(NSNotification *)aNotification{
    NSLog(@"keyboardWillShow");
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"kbSize.height: %f", kbSize.height);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    backgroundScrollView.contentInset = contentInsets;
    backgroundScrollView.scrollIndicatorInsets = contentInsets;
    NSLog(@"check %f", backgroundScrollView.contentInset.bottom);
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, commentTextView.frame.origin) ) {
        [backgroundScrollView scrollRectToVisible:commentTextView.frame animated:YES];
    }
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{

}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSLog(@"keyboardWillBeHidden");
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    backgroundScrollView.contentInset = contentInsets;
    backgroundScrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"textView.contentSize.height: %f", textView.contentSize.height);
//    [textView setFrame:CGRectMake(textView.frame.origin.x, 300-textView.contentSize.height, 320, textView.contentSize.height)];
    
    NSString *trimmedComment = [commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSLog(@"len: %d", trimmedComment.length);
    if (trimmedComment.length != 0){
        commentButton.enabled = true;
    }else{
        commentButton.enabled = false;
    }
}

-(IBAction)tableHeaderViewButtonTapped{
    NSLog(@"photo show");
    PhotoViewController *photoViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    [photoViewController setObject:annotation.object];
    [[self navigationController] pushViewController:photoViewController animated:YES];
}

@end
