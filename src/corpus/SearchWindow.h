#import <Cocoa/Cocoa.h>

@class MainView;

@interface SearchWindow : NSWindow {
	NSView *childContentView;
    NSTextField *searchBar;
    CGSize startingSize;
}
- (void)setShowingResults: (BOOL)showing;

@end
