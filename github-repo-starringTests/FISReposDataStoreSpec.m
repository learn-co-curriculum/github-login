//
//  FISReposDataStoreSpec.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/6/14.
//  Copyright 2014 Joe Burgess. All rights reserved.
//

#import "Specta.h"
#import "FISReposDataStore.h"
#define EXP_SHORTHAND
#import <Expecta.h>
#import <OHHTTPStubs.h>
#import "FISGithubRepository.h"
#define MOCKITO_SHORTHAND
#import <OCMockito.h>
#import "FISGithubAPIClient.h"
#import <Swizzlean.h>

SpecBegin(FISReposDataStore)

describe(@"FISReposDataStore", ^{
    
    beforeAll(^{
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
    });

    beforeEach(^{

    });

    it(@"Should alloc the repositories array", ^{
        FISReposDataStore *dataStore = [[FISReposDataStore alloc] init];
        expect(dataStore.repositories).toNot.beNil();
    });

    describe(@"Shared singleton method", ^{
        it(@"Should have a sharedDataStore class method", ^{
            expect([FISReposDataStore class]).to.respondTo(@selector(sharedDataStore));
        });
        
        it(@"Should be a singleton", ^{
            expect([FISReposDataStore sharedDataStore]).to.beIdenticalTo([FISReposDataStore sharedDataStore]);
        });
    });

    describe(@"getRepositories Method", ^{

        it(@"Should set success to YES if everything works", ^AsyncBlock{
            FISReposDataStore *dataStore = [[FISReposDataStore alloc] init];
            [dataStore getRepositoriesWithCompletion:^(BOOL success) {
                expect(success).to.beTruthy;
                done();
            }];
        });

        it(@"Should Get The Correct Repositories", ^AsyncBlock{

            FISGithubRepository *repo1 = [[FISGithubRepository alloc] init];
            repo1.repositoryID=@"1";
            repo1.fullName=@"mojombo/grit";
            repo1.htmlURL=[NSURL URLWithString:@"https://github.com/mojombo/grit"];
            FISGithubRepository *repo2 = [[FISGithubRepository alloc] init];
            repo2.repositoryID = @"26";
            repo2.fullName = @"wycats/merb-core";
            repo2.htmlURL=[NSURL URLWithString:@"https://github.com/wycats/merb-core"];
            NSArray *correctRepos = [[NSMutableArray alloc] initWithArray:@[repo1,repo2]];
            FISReposDataStore *dataStore = [[FISReposDataStore alloc] init];

            [dataStore getRepositoriesWithCompletion:^(BOOL success) {
                expect([dataStore.repositories count]).to.equal(2);
                expect(dataStore.repositories).to.equal(correctRepos);
                done();
            }];
        });
    });

    describe(@"toggleStar Method", ^{
        __block Swizzlean *starRepoSwizzle;
        __block Swizzlean *unstarRepoSwizzle;
        __block Swizzlean *checkStarSwizzle;
        __block BOOL calledStarRepo;
        __block BOOL calledUnStarRepo;
        __block BOOL calledCheckStarRepo;
        __block FISGithubRepository *mockedRepo;

        beforeAll(^{
            mockedRepo = mock([FISGithubRepository class]);
            [given(mockedRepo.fullName) willReturn:@"wycats/merb-core"];
            starRepoSwizzle = [[Swizzlean alloc] initWithClassToSwizzle:[FISGithubAPIClient class]];
            unstarRepoSwizzle = [[Swizzlean alloc] initWithClassToSwizzle:[FISGithubAPIClient class]];
            checkStarSwizzle = [[Swizzlean alloc] initWithClassToSwizzle:[FISGithubAPIClient class]];
            [starRepoSwizzle swizzleClassMethod:@selector(starRepoWithFullName:CompletionBlock:) withReplacementImplementation:^(id _self, NSString *fullName, void (^completionBlock)(void)){
                calledStarRepo=YES;
                completionBlock();
            }];
            [starRepoSwizzle swizzleClassMethod:@selector(unstarRepoWithFullName:CompletionBlock:) withReplacementImplementation:^(id _self, NSString *fullName, void (^completionBlock)(void)){
                calledUnStarRepo=YES;
                completionBlock();
            }];

        });

        beforeEach(^{

            calledCheckStarRepo = NO;
            calledStarRepo = NO;
            calledUnStarRepo = NO;
        });

        it(@"should star a repo if it is unstarred", ^AsyncBlock{
            [checkStarSwizzle swizzleClassMethod:@selector(checkIfRepoIsStarredWithFullName:CompletionBlock:) withReplacementImplementation:^(id _self, NSString *fullName, void (^completionBlock)(BOOL)){
                calledCheckStarRepo = YES;
                expect(fullName).to.equal(mockedRepo.fullName);
                completionBlock(NO);
            }];

            FISReposDataStore *dataStore = [[FISReposDataStore alloc] init];

            [dataStore toggleStarForRepo:mockedRepo CompletionBlock:^(BOOL starred) {
                expect(starred).to.beTruthy();
                expect(calledStarRepo).to.beTruthy();
                expect(calledCheckStarRepo).to.beTruthy();
                expect(calledUnStarRepo).to.beFalsy();
                done();
            }];

        });

        it(@"should unstar a repo if it is starred", ^AsyncBlock {
            [checkStarSwizzle swizzleClassMethod:@selector(checkIfRepoIsStarredWithFullName:CompletionBlock:) withReplacementImplementation:^(id _self, NSString *fullName, void (^completionBlock)(BOOL)){
                calledCheckStarRepo = YES;
                expect(fullName).to.equal(mockedRepo.fullName);
                completionBlock(YES);
            }];

            FISReposDataStore *dataStore = [[FISReposDataStore alloc] init];

            [dataStore toggleStarForRepo:mockedRepo CompletionBlock:^(BOOL starred) {
                expect(starred).to.beFalsy();
                expect(calledStarRepo).to.beFalsy();
                expect(calledCheckStarRepo).to.beTruthy();
                expect(calledUnStarRepo).to.beFalsy();
                done();
            }];
        });

        afterEach(^{
            [checkStarSwizzle resetSwizzledClassMethod];
        });
    });

    afterEach(^{

    });
    
    afterAll(^{

    });
});

SpecEnd
