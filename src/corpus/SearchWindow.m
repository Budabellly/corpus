#import "SearchWindow.h"
#import "MainView.h"
#import <MASShortcut/Shortcut.h>

@implementation SearchWindow

- (void)setup {
    NSString *defaultsKey = @"SearchHotkey";
    MASShortcut *shortcut = [MASShortcut shortcutWithKeyCode:kVK_ANSI_V modifierFlags:NSControlKeyMask];
    [[MASShortcutBinder sharedBinder] registerDefaultShortcuts:@{defaultsKey: shortcut}];
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:defaultsKey toAction:^{
        [NSApp activateIgnoringOtherApps:YES];
        [self makeKeyAndOrderFront:nil];
    }];
    CGSize size = self.frame.size;
    CGSize windowSize = [NSScreen mainScreen].frame.size;
    [self setFrame:CGRectMake((windowSize.width - size.width) / 2, (windowSize.height - size.height) / 2, size.width, size.height) display:YES animate:NO];
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
		
		[[NSNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(mainWindowChanged:)
			name:NSWindowDidBecomeMainNotification
			object:self];
		
		[[NSNotificationCenter defaultCenter]
			addObserver:self
			selector:@selector(mainWindowChanged:)
			name:NSWindowDidResignMainNotification
			object:self];
	}
    [self setup];
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

- (void)mainWindowChanged:(NSNotification *)aNotification {
	// [closeButton setNeedsDisplay];
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

		closeButton = [NSWindow standardWindowButton:NSWindowCloseButton forStyleMask:NSTitledWindowMask];
		NSRect closeButtonRect = [closeButton frame];
		[closeButton setFrame:NSMakeRect(WINDOW_FRAME_PADDING - 20, bounds.size.height - (WINDOW_FRAME_PADDING - 20) - closeButtonRect.size.height, closeButtonRect.size.width, closeButtonRect.size.height)];
		[closeButton setAutoresizingMask:NSViewMaxXMargin | NSViewMinYMargin];
		[frameView addSubview:closeButton];
	}
	
	if (childContentView) {
		[childContentView removeFromSuperview];
	}
	childContentView = aView;
	[childContentView setFrame:[self contentRectForFrameRect:bounds]];
	[childContentView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
	[frameView addSubview:childContentView];
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