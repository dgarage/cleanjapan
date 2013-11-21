static NSUInteger const kPAWWallPostsSearch = 20; // query limit for pins and tableviewcells
static double const kPAWWallPostMaximumSearchDistance = 100.0;
static NSString * const kPAWParseLocationKey = @"location";
static NSString * const kPAWParseImageKey = @"image";
static NSString * const kPAWParseUserKey = @"user";
//static NSString * const kPAWParseUsernameKey = @"username";
static NSString * const kPAWParseTitleKey = @"title";
static NSString * const kPAWParseUsernameKey = @"username";
// UI strings:
static NSString * const kPAWWallCantViewPost = @"Can’t view post! Get closer.";

#define USER_ICON_SIZE 48
#define MARGIN 8

@class ParseStarterProjectViewController;

@interface ParseStarterProjectAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet ParseStarterProjectViewController *viewController;

@end
