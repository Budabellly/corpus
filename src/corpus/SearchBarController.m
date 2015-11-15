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

- (void)search: (NSString *)query forType: (NSString *)type {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:3005/plugin/%@", type]];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:URL];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client postPath:@"" parameters:@{@"content": query} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *text = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [self.window setRows:text];
        if ([text isEqualToString:@"[]"]) {
            [self.window setShowingResults:NO];
        } else {
            [self.window setShowingResults:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.window setShowingResults:NO];
    }];
}

- (void)controlTextDidChange:(NSNotification *)notification {
    NSString *entry = [((NSTextField *)notification.object) stringValue];
    NSArray *parts = [entry componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (parts.count >= 3) {
        NSString *type = parts[0];
        NSString *query = [[parts subarrayWithRange:NSMakeRange(2, parts.count - 2)] componentsJoinedByString:@" "];
        if (query.length > 1) {
            [self search:query forType:type];
        } else {
            [self.window setShowingResults:NO];
        }
    } else {
        [self.window setShowingResults:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
