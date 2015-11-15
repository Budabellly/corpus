#import "MainView.h"

@implementation MainView

- (void)drawRect:(NSRect)rect {
    [[NSColor grayColor] set];
    NSRectFill(rect);
    
	NSMutableParagraphStyle *paragraphStyle =
		[[[NSMutableParagraphStyle alloc] init] autorelease];
	[paragraphStyle setAlignment:NSCenterTextAlignment];
}

@end
