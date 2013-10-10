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
@end

@implementation Annotation
@synthesize coordinate;
@synthesize subtitle;
@synthesize title;
@synthesize image;

- (id)initWithCoordinate:(CLLocationCoordinate2D)aCoordinate andTitle:(NSString *)aTitle andSubtitle:(NSString *)aSubtitle andImage:(UIImage *)aImage{
	self = [super init];
	if (self) {
		self.coordinate = aCoordinate;
		self.title = aTitle;
		self.subtitle = aSubtitle;
        self.image = aImage;
	}
	return self;
}

@end
