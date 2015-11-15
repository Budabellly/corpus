#import "SearchWindow.h"
#import "MainView.h"
#import <MASShortcut/Shortcut.h>
#import "SearchBarController.h"

@implementation SearchWindow

- (void)setup {
    NSString *defaultsKey = @"SearchHotkey";
    MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_ANSI_V modifierFlags:NSControlKeyMask];
    [[MASShortcutBinder sharedBinder] registerDefaultShortcuts:@{defaultsKey: shortcut}];
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:defaultsKey toAction:^{
        [NSApp activateIgnoringOtherApps:YES];
        [self makeKeyAndOrderFront:nil];
    }];
    startingSize = self.frame.size;
    web.mainFrameURL = @"http://localhost:3005/";
    [self setShowingResults:NO];
}

- (id)initWithContentRect:(NSRect)contentRect
	styleMask:(NSUInteger)windowStyle
	backing:(NSBackingStoreType)bufferingType
	defer:(BOOL)deferCreation {
	self = [super
		initWithContentRect:contentRect
		styleMask:NSBorderlessWindowMask
		backing:bufferingType
		defer:deferCreation];
	if (self) {
		[self setOpaque:NO];
		[self setBackgroundColor:[NSColor clearColor]];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter]
		removeObserver:self];
	[super dealloc];
}

- (void)setContentSize:(NSSize)newSize {
	NSSize sizeDelta = newSize;
	NSSize childBoundsSize = [childContentView bounds].size;
	sizeDelta.width -= childBoundsSize.width;
	sizeDelta.height -= childBoundsSize.height;
	
	MainView *frameView = [super contentView];
	NSSize newFrameSize = [frameView bounds].size;
	newFrameSize.width += sizeDelta.width;
	newFrameSize.height += sizeDelta.height;
    
	[super setContentSize:newFrameSize];
}

- (void)setShowingResults: (BOOL)showing {
    CGSize windowSize = [NSScreen mainScreen].frame.size;
    CGSize size;
    if (!showing) {
        size = startingSize;
        [self setFrame:CGRectMake((windowSize.width - size.width) / 2, (windowSize.height - size.height) / 2, size.width, size.height) display:YES animate:NO];
        web.hidden = YES;
    } else {
        size = CGSizeMake(startingSize.width, 300);
        [self setFrame:CGRectMake((windowSize.width - size.width) / 2, (windowSize.height - size.height) / 2, size.width, size.height) display:YES animate:NO];
        web.hidden = NO;
    }
    CGSize searchSize = searchBar.frame.size;
    [searchBar setFrame:CGRectMake(10, size.height - searchSize.height - 10, size.width - 20, searchSize.height)];
    [web setFrame:CGRectMake(10, 10, size.width - 20, 300 - searchSize.height - 30)];
}

- (void)setContentView:(NSView *)aView {
	if ([childContentView isEqualTo:aView]) {
		return;
	}
	
	NSRect bounds = [self frame];
	bounds.origin = NSZeroPoint;

	MainView *frameView = [super contentView];
	if (!frameView) {
		frameView = [[[MainView alloc] initWithFrame:bounds] autorelease];
		
		[super setContentView:frameView];
        
        searchBar = [[NSTextField alloc] initWithFrame:CGRectMake(10, 10, frameView.frame.size.width - 20, frameView.frame.size.height - 20)];
        searchBar.font = [NSFont fontWithName:@"Verdana" size:30.0];
        searchBar.delegate = [[SearchBarController alloc] init];
        ((SearchBarController *)searchBar.delegate).window = self;
        [frameView addSubview:searchBar];
	}
	
	if (childContentView) {
		[childContentView removeFromSuperview];
	}
	childContentView = aView;
	[childContentView setFrame:[self contentRectForFrameRect:bounds]];
	[childContentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	[frameView addSubview:childContentView];
    web = [[WebView alloc] init];
    [frameView addSubview:web];
    
    [self setup];
}

- (NSView *)contentView {
	return childContentView;
}

- (BOOL)canBecomeKeyWindow {
	return YES;
}

- (BOOL)canBecomeMainWindow {
	return YES;
}

- (NSRect)contentRectForFrameRect:(NSRect)windowFrame {
	windowFrame.origin = NSZeroPoint;
	return NSInsetRect(windowFrame, WINDOW_FRAME_PADDING, WINDOW_FRAME_PADDING);
}

+ (NSRect)frameRectForContentRect:(NSRect)windowContentRect styleMask:(NSUInteger)windowStyle {
	return NSInsetRect(windowContentRect, -WINDOW_FRAME_PADDING, -WINDOW_FRAME_PADDING);
}

@end