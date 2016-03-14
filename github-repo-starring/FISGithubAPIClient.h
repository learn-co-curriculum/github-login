//
//  FISGithubAPIClient.h
//  github-repo-list
//
//  Created by Joe Burgess on 5/5/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FISGithubAPIClient : NSObject

+(void)getRepositoriesWithCompletion:(void (^)(NSArray *repoDictionaries))completionBlock;

+(void)checkIfRepoIsStarredWithFullName:(NSString *)fullName
                        completionBlock:(void (^)(BOOL starred))completionBlock;

+(void)starRepoWithFullName:(NSString *)fullName
            completionBlock:(void (^)(void))completionBlock;

+(void)unstarRepoWithFullName:(NSString *)fullName
              completionBlock:(void (^)(void))completionBlock;

@end