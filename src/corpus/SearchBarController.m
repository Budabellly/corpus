//
//  SearchBarController.m
//  corpus
//
//  Created by Matt Neary on 11/14/15.
//
//

#import "SearchBarController.h"
#import <AFNetworking/AFNetworking.h>
#import "SearchWindow.h"

@interface SearchBarController ()

@end

@implementation SearchBarController

- (void)search: (NSString *)query {
    NSURL *URL = [NSURL URLWithString:@"http://localhost:3005/plugin/texts"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client postPath:@"" parameters:@{@"content": query} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [self.window setShowingResults:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.window setShowingResults:NO];
    }];
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSString *search = [((NSTextField *)notification.object) stringValue];
    if (search.length > 5) {
        [self search:search];
    } else {
        [self.window setShowingResults:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
