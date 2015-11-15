//
//  SearchBarController.h
//  corpus
//
//  Created by Matt Neary on 11/14/15.
//
//

#import <Cocoa/Cocoa.h>

@class SearchWindow;
@interface SearchBarController : NSViewController <NSTextFieldDelegate>
@property SearchWindow *window;
@end
