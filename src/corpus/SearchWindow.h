#import <Cocoa/Cocoa.h>

@class MainView;

@interface SearchWindow : NSWindow {
	NSView *childContentView;
    NSTextField *searchBar;
}

@end
