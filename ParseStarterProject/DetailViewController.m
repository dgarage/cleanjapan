//
//  DetailViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/10/13.
//
//
#define UserIconSize 48

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
    self.automaticallyAdjustsScrollViewInsets = false;
    
//    //background scrollview
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    //background scroll view
    backgroundScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    backgroundScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundScrollView];
    
    int marginTop = [UIApplication sharedApplication].statusBarFrame.size.height+self.navigationController.navigationBar.bounds.size.height;
    
    //commetButton
    CGSize commentButtonSize = CGSizeMake(60, 40);
    commentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    commentButton.frame = CGRectMake(self.view.bounds.size.width-commentButtonSize.width, self.view.bounds.size.height-commentButtonSize.height, commentButtonSize.width, commentButtonSize.height);
    commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    commentButton.backgroundColor = [UIColor lightGrayColor];
    [commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
    
    //commentTextView
    int commentTextViewHeight = commentButtonSize.height;
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-commentTextViewHeight, self.view.bounds.size.width-commentButtonSize.width, commentTextViewHeight)];
    commentTextView.layer.borderWidth = 1.0f;
    commentTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    commentTextView.backgroundColor = [UIColor whiteColor];
    [backgroundScrollView addSubview:commentButton];
    [backgroundScrollView addSubview:commentTextView];
    

    //tableView
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, marginTop+self.view.bounds.origin.y,  self.view.bounds.size.width, self.view.bounds.size.height-commentTextView.frame.size.height-marginTop) style:UITableViewStylePlain];
    commentTableView.backgroundColor = [UIColor whiteColor];
    
    //**** Table Header View ********
    int tableHeaderViewLabelHeight = 30;
    //- tableHeaderViewUserNameLabel
    tableHeaderViewUserNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, tableHeaderViewLabelHeight)];
    tableHeaderViewUserNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    //- tableHeaderViewTextView
    int tableHeaderViewTextViewHeight = 30;
    tableHeaderViewTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, tableHeaderViewUserNameLabel.bounds.size.height, self.view.bounds.size.width, tableHeaderViewTextViewHeight)];
    tableHeaderViewTextView.font = [UIFont systemFontOfSize:16.0f];
    //- tableHeaderViewCreatedAtLabel
    int tableHeaderViewCreatedAtLabelHeight = 30;
    tableHeaderViewCreatedAtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tableHeaderViewUserNameLabel.bounds.size.height+tableHeaderViewTextView.bounds.size.height, self.view.bounds.size.width, tableHeaderViewCreatedAtLabelHeight)];
    tableHeaderViewCreatedAtLabel.font = [UIFont systemFontOfSize:14.0f];
    //- tableHeaderViewButton
    tableHeaderViewTextView.text = [NSString stringWithFormat:@"%@", [annotation.object objectForKey:@"title"]];
    tableHeaderViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tableHeaderViewButton.frame = CGRectMake(0, tableHeaderViewUserNameLabel.bounds.size.height+tableHeaderViewTextView.bounds.size.height+tableHeaderViewCreatedAtLabel.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.width);
    [tableHeaderViewButton addTarget:self action:@selector(tableHeaderViewButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    PFFile *imageFile = [annotation.object objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            [tableHeaderViewButton setBackgroundImage:image forState:UIControlStateNormal];
        }
    }];
    //check the post was by anonymous or not
    if ([[annotation.object objectForKey:@"user"] objectForKey:@"email"] == NULL) {
        //anonymous user's post
        tableHeaderViewUserNameLabel.text = [@"Guest ID:" stringByAppendingString:[[annotation.object objectForKey:@"user"] objectId]];
    }else{
        //not anonymous's post
        tableHeaderViewUserNameLabel.text = [[annotation.object objectForKey:@"user"] objectForKey:@"username"];
    }
    
    
    UIView * tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, tableHeaderViewButton.bounds.size.height+tableHeaderViewUserNameLabel.bounds.size.height+tableHeaderViewTextView.bounds.size.height+tableHeaderViewCreatedAtLabel.bounds.size.height)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    [tableHeaderView addSubview:tableHeaderViewUserNameLabel];
    [tableHeaderView addSubview:tableHeaderViewTextView];
    [tableHeaderView addSubview:tableHeaderViewCreatedAtLabel];
    [tableHeaderView addSubview:tableHeaderViewButton];
    
    UIImageView *userIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [tableHeaderView addSubview:userIconImageView];

    UIImage *identicon = [Identicon identiconWithString:[[annotation.object objectForKey:@"user"] objectId] size:CGSizeMake(UserIconSize, UserIconSize)];
    userIconImageView.image = identicon;
    
    
//    
//    [CommentTableViewCell sizeThatFits:CGSizeMake(tableHeaderView.bounds.size.width, tableHeaderView.bounds.size.height-tableHeaderViewButton.bounds.size.height) userIconViewFrame:userIconImageView userNameLabel:tableHeaderViewUserNameLabel commentLabel:tableHeaderViewUserNameLabel createdAtLabel:tableHeaderViewCreatedAtLabel withLayout:YES];
    
    //comment table view
    [commentTableView setTableHeaderView:tableHeaderView];
    [backgroundScrollView addSubview:commentTableView];
    
    
    [commentButton setTitle:NSLocalizedString(@"comment", @"") forState:UIControlStateNormal];

    
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
    [commentTableView setNeedsLayout];
    NSLog(@"takenoko");
    getHeightCell = [[CommentTableViewCell alloc] init];
}

- (void)viewDidLayoutSubviews{
    [backgroundScrollView setContentSize:backgroundScrollView.frame.size];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell){
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setupCommentObject:[commentObjectArray objectAtIndex:indexPath.row]];

    //    CGRect commentLabelFrame = [cell.commentLabel frame];
    //    NSLog(@"pos: %f %f", commentLabelFrame.origin.x, commentLabelFrame.origin.y);
    //    commentLabelFrame.size = CGSizeMake(280, CGFLOAT_MAX);
    //    [cell.commentLabel setFrame:commentLabelFrame];
    //    [cell.commentLabel sizeToFit];
    //    [cell.commentLabel setFrame:CGRectMake(commentLabelFrame.origin.x, commentLabelFrame.origin.y, cell.commentLabel.frame.size.width, cell.commentLabel.frame.size.height)];
    
    return cell;
}


////セルの高さをUILabelに合わせて設定
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    
//    NSString *newcellHeight = [tweetTextArray objectAtIndex:indexPath.row];
//	//CGSizeMakeの5000は大きければ適当な値でOK
//    CGSize size = [newcellHeight sizeWithFont:[UIFont systemFontOfSize:12.0]
//                            constrainedToSize:CGSizeMake(170, 5000)
//                                lineBreakMode:NSLineBreakByWordWrapping];
    
    
//    [getHeightCell]
    //+45はマージン
    [getHeightCell setupCommentObject:[commentObjectArray objectAtIndex:indexPath.row]];
    CGSize size;
    size.width = commentTableView.frame.size.width;
    size.height = CGFLOAT_MAX;
    size = [getHeightCell sizeThatFits:size];
    NSLog(@"size:%f", size.height);
//    
//    
//    PFObject *cellObject = [commentObjectArray objectAtIndex:indexPath.row];
//    float cellHeight =  [self getCellHeight:[[cellObject objectForKey:@"user"] objectForKey:@"username"] comment:[cellObject objectForKey:@"comment"] createdAt:[cellObject createdAt]];
    
    return size.height;
}

- (float)getCellHeight:(NSString*)userName comment:(NSString*)comment createdAt:(NSDate*)createdAt{
    CGSize userNameLabelSize = [userName sizeWithFont:[UIFont boldSystemFontOfSize:16.0]
                                               constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)
                                                   lineBreakMode:NSLineBreakByWordWrapping];
    CGSize commentLabelSize = [comment sizeWithFont:[UIFont systemFontOfSize:16.0]
                                   constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)
                                       lineBreakMode:NSLineBreakByWordWrapping];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *theDate = [dateFormatter stringFromDate:createdAt];
    CGSize createdAtLabelSize = [theDate sizeWithFont:[UIFont systemFontOfSize:14.0]
                                      constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)
                                          lineBreakMode:NSLineBreakByWordWrapping];
    float cellHeight = userNameLabelSize.height+commentLabelSize.height+createdAtLabelSize.height;
    return cellHeight;
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
            commentButton.enabled = false;
            [self dismissKeyboard];
            [self retrieveComment];
        }
    }];
}

- (void)retrieveComment{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"postObjectId" equalTo:[annotation.object objectId]];
    [query includeKey:kPAWParseUserKey];
    [query orderByAscending:@"createdAt"];
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
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    PhotoViewController *photoViewController = [storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    [photoViewController setObject:annotation.object];
    [[self navigationController] pushViewController:photoViewController animated:YES];
}

@end
