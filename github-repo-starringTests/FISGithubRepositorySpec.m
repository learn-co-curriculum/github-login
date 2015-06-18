//
//  FISGithubRepositorySpec.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/6/14.
//  Copyright 2014 Joe Burgess. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import <Expecta.h>
#import "FISGithubRepository.h"


SpecBegin(FISGithubRepository)

describe(@"FISGithubRepository", ^{

    __block FISGithubRepository *repo;
    beforeAll(^{

    });
    
    beforeEach(^{
        repo=[[FISGithubRepository alloc] init];
    });
    
    it(@"should have an NSString fullName property ", ^{
        expect(repo).to.respondTo(@selector(fullName));
        expect(repo).to.respondTo(@selector(setFullName:));

        repo.fullName=@"testing";
        expect(repo.fullName).to.beKindOf([NSString class]);
        expect(repo.fullName).to.equal(@"testing");
    });

    it(@"should have an NSURL htmlURL property ", ^{
        expect(repo).to.respondTo(@selector(htmlURL));
        expect(repo).to.respondTo(@selector(setHtmlURL:));

        repo.htmlURL=[NSURL URLWithString:@"testing"];
        expect(repo.htmlURL).to.beKindOf([NSURL class]);
        expect(repo.htmlURL).to.equal([NSURL URLWithString:@"testing"]);
    });

    it(@"should have an NSString repositoryID property ", ^{
        expect(repo).to.respondTo(@selector(repositoryID));
        expect(repo).to.respondTo(@selector(setRepositoryID:));

        repo.repositoryID=@"url";
        expect(repo.repositoryID).to.beKindOf([NSString class]);
        expect(repo.repositoryID).to.equal(@"url");
    });

    describe(@"isEqual method", ^{
        it(@"should return YES for identical content", ^{
            FISGithubRepository *repo1 = [[FISGithubRepository alloc] init];
            repo1.repositoryID=@"1";
            repo1.fullName=@"mojombo/grit";
            repo1.htmlURL=[NSURL URLWithString:@"https://github.com/mojombo/grit"];
            FISGithubRepository *repo2 = [[FISGithubRepository alloc] init];
            repo2.repositoryID = @"1";
            repo2.fullName = @"mojombo/grit";
            repo2.htmlURL=[NSURL URLWithString:@"https://github.com/mojombo/grit"];

            expect([repo1 isEqual:repo2]).to.beTruthy;
        });

        it(@"should return NO if fullName different", ^{
            FISGithubRepository *repo1 = [[FISGithubRepository alloc] init];
            repo1.repositoryID=@"1";
            repo1.fullName=@"somethingElse";
            repo1.htmlURL=[NSURL URLWithString:@"https://github.com/mojombo/grit"];
            FISGithubRepository *repo2 = [[FISGithubRepository alloc] init];
            repo2.repositoryID = @"1";
            repo2.fullName = @"mojombo/grit";
            repo2.htmlURL=[NSURL URLWithString:@"https://github.com/mojombo/grit"];

            expect([repo1 isEqual:repo2]).toNot.beTruthy;
        });

        it(@"should return NO if repositoryID is different", ^{
            FISGithubRepository *repo1 = [[FISGithubRepository alloc] init];
            repo1.repositoryID=@"10";
            repo1.fullName=@"mojombo/grit";
            repo1.htmlURL=[NSURL URLWithString:@"https://github.com/mojombo/grit"];
            FISGithubRepository *repo2 = [[FISGithubRepository alloc] init];
            repo2.repositoryID = @"1";
            repo2.fullName = @"mojombo/grit";
            repo2.htmlURL=[NSURL URLWithString:@"https://github.com/mojombo/grit"];

            expect([repo1 isEqual:repo2]).toNot.beTruthy;
        });

        it(@"should return NO if htmlURL is different", ^{
            FISGithubRepository *repo1 = [[FISGithubRepository alloc] init];
            repo1.repositoryID=@"1";
            repo1.fullName=@"mojombo/grit";
            repo1.htmlURL=[NSURL URLWithString:@"https://github.com/jmburges/grit"];
            FISGithubRepository *repo2 = [[FISGithubRepository alloc] init];
            repo2.repositoryID = @"1";
            repo2.fullName = @"mojombo/grit";
            repo2.htmlURL=[NSURL URLWithString:@"https://github.com/mojombo/grit"];

            expect([repo1 isEqual:repo2]).toNot.beTruthy;
        });
    });

    describe(@"Create repo from NSDictionary", ^{
        __block NSDictionary *repoDictionary;
        __block NSURL *correctURL;
        __block NSString *correctFullName;
        __block NSString *correctRepositoryID;
        beforeAll(^{
            repoDictionary = @{@"html_url":@"https://github.com",
                               @"full_name":@"test/test",
                               @"id":@2};
            correctURL = [NSURL URLWithString:repoDictionary[@"html_url"]];
            correctFullName = repoDictionary[@"full_name"];
            correctRepositoryID = [repoDictionary[@"id"] stringValue];
        });
        it(@"Should respond to repoFromDictionary", ^{
            expect([FISGithubRepository class]).to.respondTo(@selector(repoFromDictionary:));
        });

        it(@"Should return an FISGithubRepository", ^{
            expect([FISGithubRepository repoFromDictionary:repoDictionary]).to.beInstanceOf([FISGithubRepository class]);
        });

        it(@"Should return the correct data types", ^{
            FISGithubRepository *repo = [FISGithubRepository repoFromDictionary:repoDictionary];
            expect(repo.htmlURL).to.beKindOf([NSURL class]);
            expect(repo.fullName).to.beKindOf([NSString class]);
            expect(repo.repositoryID).to.beKindOf([NSString class]);
        });

        it(@"Should return the correct data", ^{
            FISGithubRepository *repo = [FISGithubRepository repoFromDictionary:repoDictionary];
            expect(repo.htmlURL).to.equal(correctURL);
            expect(repo.repositoryID).to.equal(correctRepositoryID);
            expect(repo.fullName).to.equal(correctFullName);
        });

    });

});

SpecEnd
