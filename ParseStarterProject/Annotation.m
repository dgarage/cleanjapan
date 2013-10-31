//
//  Annotation.m
//  ParseStarterProject
//
//  Created by 藤賀 雄太 on 10/10/13.
//
//

#import "Annotation.h"

@interface Annotation ()
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) UIImage *image;
@property (nonatomic, strong) PFObject *object;
@property (nonatomic, strong) PFGeoPoint *geopoint;
@property (nonatomic, strong) PFUser *user;
@end

@implementation Annotation
@synthesize coordinate;
@synthesize subtitle;
@synthesize title;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle{
	self = [super init];
	if (self) {
		self.coordinate = aCoordinate;
		self.title = aTitle;
		self.subtitle = aSubtitle;
        
        self.animatesDrop = NO;
	}
	return self;
}

- (id)initWithPFObject:(PFObject *)anObject {
	self.object = anObject;
	self.geopoint = [anObject objectForKey:kPAWParseLocationKey];
	self.user = [anObject objectForKey:kPAWParseUserKey];
    [anObject fetchIfNeeded];
	NSString *aTitle = [anObject objectForKey:kPAWParseTitleKey];//comment
    NSString *aSubtitle;
    //check the post was by anonymous or not
    if ([[anObject objectForKey:@"user"] objectForKey:@"email"] == NULL) {
        //anonymous user's post
        aSubtitle = [@"Guest ID:" stringByAppendingString:[[anObject objectForKey:@"user"] objectId]];
    }else{
        //not anonymous's post
        aSubtitle = [[anObject objectForKey:kPAWParseUserKey] objectForKey:kPAWParseUsernameKey];//username
    }
    CLLocationCoordinate2D aCoordinate = CLLocationCoordinate2DMake(self.geopoint.latitude, self.geopoint.longitude);
//    UIImage *anImage = [anObject objectForKey:kPAWParseImageKey];
    return [self initWithCoordinate:aCoordinate andTitle:aTitle andSubtitle:aSubtitle];
}

- (BOOL)equalToPost:(Annotation *)aPost {
	if (aPost == nil) {
		return NO;
	}
    
	if (aPost.object && self.object) {
		// We have a PFObject inside the PAWPost, use that instead.
		if ([aPost.object.objectId compare:self.object.objectId] != NSOrderedSame) {
			return NO;
		}
		return YES;
	} else {
		// Fallback code:
        
		if ([aPost.title compare:self.title] != NSOrderedSame ||
			[aPost.subtitle compare:self.subtitle] != NSOrderedSame ||
			aPost.coordinate.latitude != self.coordinate.latitude ||
			aPost.coordinate.longitude != self.coordinate.longitude ) {
			return NO;
		}
        
		return YES;
	}
}

@end
