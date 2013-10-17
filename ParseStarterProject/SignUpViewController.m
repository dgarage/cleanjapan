//
//  SignUpViewController.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/17/13.
//
//
#define TAG_USER_ID 1
#define TAG_PASSWORD 2
#import "SignUpViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp{
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
            // Show the errorString somewhere and let the user try again.
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"foo";
    
    //label
    //textField
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(130.0, -2, 200.0, 50.0)];
    textField.delegate = self;
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"Username";
        textField.placeholder = @"Username";
        textField.secureTextEntry = NO;
        textField.returnKeyType = UIReturnKeyNext;
    }
    else
    {
        cell.textLabel.text = @"Password";
        textField.placeholder = @"Password";
        textField.secureTextEntry = YES;
        textField.returnKeyType = UIReturnKeyDone;
    }
    [cell.contentView addSubview:textField];
    return cell;
}

- (void)textFieldShouldReturn:(UITextField *)textField {
//    if (textField.tag == TAG_USER_ID)
//    {
//        // TableのIndexPathリストを取得
//        NSArray *indexPathArr = loginInputTbl.indexPathsForVisibleRows;
//        // パスワードセルのIndexPathを取得
//        NSIndexPath *indexPathPassword = [indexPathArr objectAtIndex:ROW_IDX_PASSWORD];
//        // パスワードのセルを取得
//        UITableViewCell *cellPass = [loginInputTbl cellForRowAtIndexPath:indexPathPassword];
//        UITextField *passText = (UITextField*)[cellPass viewWithTag:TAG_PASSWORD];
//        // パスワードの入力開始（カーソルセット）
//        [passText becomeFirstResponder];
//    }
//    else
//    {
//        // キーボードを閉じる
//        [textField resignFirstResponder];
//    }
//    return YES;
}

// セクション数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// tableのリスト件数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

@end
