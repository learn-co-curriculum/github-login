//
//  FISReposDataStore.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISReposDataStore.h"
#import "FISGithubAPIClient.h"
#import "FISGithubRepository.h"

@implementation FISReposDataStore
+ (instancetype)sharedDataStore {
    static FISReposDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [[FISReposDataStore alloc] init];
    });

    return _sharedDataStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _repositories=[NSMutableArray new];
    }
    return self;
}
-(void)getRepositoriesWithCompletion:(void (^)(BOOL))completionBlock
{
    [FISGithubAPIClient getRepositoriesWithCompletion:^(NSArray *repoDictionaries) {
        for (NSDictionary *repoDictionary in repoDictionaries) {
            [self.repositories addObject:[FISGithubRepository repoFromDictionary:repoDictionary]];
        }
        completionBlock(YES);
    }];
}

-(void)toggleStarForRepo:(FISGithubRepository *)repo completionBlock:(void (^)(BOOL))completionBlock
{
    [FISGithubAPIClient checkIfRepoIsStarredWithFullName:repo.fullName completionBlock:^(BOOL starred) {

        if (starred) {
            [FISGithubAPIClient unstarRepoWithFullName:repo.fullName completionBlock:^{
                completionBlock(NO);
            }];
        } else
        {
            [FISGithubAPIClient starRepoWithFullName:repo.fullName completionBlock:^{
                completionBlock(YES);
            }];
        }
    }];
}
@end
