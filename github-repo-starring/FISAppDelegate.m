//
//  FISAppDelegate.m
//  github-repo-starring
//
//  Created by Joe Burgess on 5/12/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISAppDelegate.h"
#import <OHHTTPStubs.h>
static BOOL isRunningTests(void) __attribute__((const));

@implementation FISAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    if (isRunningTests()) {
        self.starred = NO;
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            if ([request.URL.host isEqualToString:@"api.github.com"]&&[request.URL.path isEqualToString:@"/repositories"])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"repositories.json", nil) statusCode:200 headers:@{@"Content-Type": @"application/json"}];
        }];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            if ([request.URL.host isEqualToString:@"api.github.com"]&&[request.URL.path isEqualToString:@"/user/starred/wycats/merb-core"] && [request.HTTPMethod isEqualToString:@"GET"])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            if(self.starred)
            {
                return [OHHTTPStubsResponse responseWithData:nil statusCode:204 headers:nil];
            } else
            {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"not_starred.json", nil) statusCode:404 headers:@{@"Content-Type": @"application/json"}];
            }
        }];

        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            if ([request.URL.host isEqualToString:@"api.github.com"]&&[request.URL.path isEqualToString:@"/user/starred/wycats/merb-core"] && ([request.HTTPMethod isEqualToString:@"PUT"]||[request.HTTPMethod isEqualToString:@"DELETE"]))
            {
                return YES;
            }
            else
            {
                return NO;
            }
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            return [OHHTTPStubsResponse responseWithData:nil statusCode:204 headers:nil];
        }];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

static BOOL isRunningTests(void)
{
    NSDictionary* environment = [[NSProcessInfo processInfo] environment];
    NSString* injectBundle = environment[@"XCInjectBundle"];
    return [[injectBundle pathExtension] isEqualToString:@"xctest"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
