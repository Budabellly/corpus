#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@class MainView;

@interface SearchWindow : NSWindow {
	NSView *childContentView;
    NSTextField *searchBar;
    CGSize startingSize;
    WebView *web;
}
- (void)setShowingResults: (BOOL)showing;

@end
