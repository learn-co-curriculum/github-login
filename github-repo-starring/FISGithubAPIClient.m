//
//  FISGithubAPIClient.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISGithubAPIClient.h"
#import "FISConstants.h"
#import "AFNetworking.h"

@implementation FISGithubAPIClient

NSString *const GITHUB_API_URL=@"https://api.github.com";

+(void)getRepositoriesWithCompletion:(void (^)(NSArray *))completionBlock {
    NSString *githubURL = [NSString stringWithFormat:@"%@/repositories?client_id=%@&client_secret=%@",GITHUB_API_URL,GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:githubURL
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             completionBlock(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSLog(@"Fail: %@",error.localizedDescription);
         }];
}

+(void)checkIfRepoIsStarredWithFullName:(NSString *)fullName
                        completionBlock:(void (^)(BOOL))completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@/user/starred/%@?client_id=%@&client_secret=%@",GITHUB_API_URL,fullName, GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
    [serializer setAuthorizationHeaderFieldWithUsername:GITHUB_ACCESS_TOKEN password:@""];
    manager.requestSerializer = serializer;

    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             if (response.statusCode == 204) {
                 completionBlock(YES);
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             NSLog(@"ERROR:%@",error.localizedDescription);
             if (response.statusCode == 404 ) {
                 completionBlock(NO);
             }
         }];
}

+(void)starRepoWithFullName:(NSString *)fullName
            completionBlock:(void (^)(void))completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@/user/starred/%@?client_id=%@&client_secret=%@",GITHUB_API_URL,fullName, GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
    [serializer setAuthorizationHeaderFieldWithUsername:GITHUB_ACCESS_TOKEN password:@""];
    manager.requestSerializer = serializer;

    [manager PUT:url
      parameters:nil
         success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAIL:%@",error.localizedDescription);
    }];
}

+(void)unstarRepoWithFullName:(NSString *)fullName
              completionBlock:(void (^)(void))completionBlock {
    NSString *url = [NSString stringWithFormat:@"%@/user/starred/%@?client_id=%@&client_secret=%@",GITHUB_API_URL,fullName, GITHUB_CLIENT_ID,GITHUB_CLIENT_SECRET];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    AFHTTPRequestSerializer *serializer = [[AFHTTPRequestSerializer alloc] init];
    [serializer setAuthorizationHeaderFieldWithUsername:GITHUB_ACCESS_TOKEN password:@""];
    manager.requestSerializer = serializer;

    [manager DELETE:url
         parameters:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
        completionBlock();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FAIL:%@",error.localizedDescription);
    }];
}

@end
