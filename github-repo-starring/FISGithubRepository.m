//
//  FISGithubRepository.m
//  ReviewSession 3-16-14
//
//  Created by Joe Burgess on 3/16/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import "FISGithubRepository.h"

@implementation FISGithubRepository

-(BOOL)isEqual:(id)object
{
    FISGithubRepository *repo2 = (FISGithubRepository *)object;
    NSString *urlA = [self.htmlURL absoluteString];
    NSString *urlB = [repo2.htmlURL absoluteString];
    return [repo2.repositoryID isEqualToString:self.repositoryID] && [repo2.fullName isEqualToString:repo2.fullName] && [urlA isEqualToString:urlB];
}

+(FISGithubRepository *)repoFromDictionary:(NSDictionary *)repoDictionary
{
    FISGithubRepository *repo = [[FISGithubRepository alloc] init];
    repo.repositoryID = [repoDictionary[@"id"] stringValue];
    repo.fullName=repoDictionary[@"full_name"];
    repo.htmlURL=[NSURL URLWithString:repoDictionary[@"html_url"]];
    return repo;
}
@end
