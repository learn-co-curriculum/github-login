//
//  FISGithubRepository.h
//  ReviewSession 3-16-14
//
//  Created by Joe Burgess on 3/16/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FISGithubRepository : NSObject

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSURL *htmlURL;
@property (strong, nonatomic) NSString *repositoryID;

+(FISGithubRepository *)repoFromDictionary:(NSDictionary *)repoDictionary;

@end
