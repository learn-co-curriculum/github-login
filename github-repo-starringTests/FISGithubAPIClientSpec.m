//
//  FISGithubAPIClientSpec.m
//  github-repo-list
//
//  Created by Joe Burgess on 5/6/14.
//  Copyright 2014 Joe Burgess. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import <Expecta.h>
#import "FISGithubAPIClient.h"
#import <OHHTTPStubs.h>


SpecBegin(FISGithubAPIClient)

describe(@"FISGithubAPIClient", ^{

    __block NSArray *repositoryArray;
    NSString *fullName = @"wycats/merb-core";
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
        
        NSData *data = [NSData dataWithContentsOfFile:OHPathForFileInBundle(@"repositories.json", nil)];
        repositoryArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    });
    

    describe(@"Get Repositories", ^{

        it(@"Should respond to getrepositories class method selector", ^{
            expect([FISGithubAPIClient class]).to.respondTo(@selector(getRepositoriesWithCompletion:));
        });

        it(@"Should get repositories", ^AsyncBlock{
            [FISGithubAPIClient getRepositoriesWithCompletion:^(NSArray *repoDictionaries) {
                expect(repoDictionaries).toNot.beNil();
                expect(repoDictionaries.count).to.equal(2);
                expect(repoDictionaries).to.equal(repositoryArray);
                done();
            }];
        });
    });

    describe(@"Check If Starred", ^{

        it(@"Should respond to checkStarred class method selector", ^{
            expect([FISGithubAPIClient class]).to.respondTo(@selector(checkIfRepoIsStarredWithFullName:CompletionBlock:));
        });

        it(@"Should respond NO when not already starred", ^AsyncBlock{
            __block BOOL calledGithubAPI=NO;
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                if ([request.URL.host isEqualToString:@"api.github.com"]&&[request.URL.path isEqualToString:@"/user/starred/wycats/merb-core"] && [request.HTTPMethod isEqualToString:@"GET"])
                {
                    calledGithubAPI=YES;
                    return YES;
                }
                else
                {
                    return NO;
                }
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"not_starred.json", nil) statusCode:404 headers:@{@"Content-Type": @"application/json"}];
            }];
            [FISGithubAPIClient checkIfRepoIsStarredWithFullName:fullName CompletionBlock:^(BOOL starred) {
                expect(starred).to.beFalsy;
                done();
            }];
            expect(calledGithubAPI).will.beTruthy(); //Check that the correct Request was called
        });

        it(@"Should respond YES when already starred", ^AsyncBlock{
            __block BOOL calledGithubAPI=NO;
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                if ([request.URL.host isEqualToString:@"api.github.com"]&&[request.URL.path isEqualToString:@"/user/starred/wycats/merb-core"] && [request.HTTPMethod isEqualToString:@"GET"])
                {
                    calledGithubAPI=YES;
                    return YES;
                }
                else
                {
                    return NO;
                }
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithData:nil statusCode:204 headers:nil];
            }];
            [FISGithubAPIClient checkIfRepoIsStarredWithFullName:fullName CompletionBlock:^(BOOL starred) {
                expect(starred).to.beTruthy;
                done();
            }];
            expect(calledGithubAPI).will.beTruthy(); //Check that the correct request was sent
        });

        afterEach(^{
            [OHHTTPStubs removeAllStubs];
        });
    });

    describe(@"Star Repo", ^{
        it(@"should star the repo", ^AsyncBlock {
            __block BOOL calledGithubAPI=NO;
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                if ([request.URL.host isEqualToString:@"api.github.com"]&&[request.URL.path isEqualToString:@"/user/starred/wycats/merb-core"] && [request.HTTPMethod isEqualToString:@"PUT"])
                {
                    calledGithubAPI=YES;
                    return YES;
                }
                else
                {
                    return NO;
                }
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithData:nil statusCode:204 headers:nil];
            }];
            [FISGithubAPIClient starRepoWithFullName:fullName CompletionBlock:^{
                done();
            }];
            expect(calledGithubAPI).will.beTruthy(); //Check that the correct request was sent
        });
    });

    describe(@"Unstar Repo", ^{
        it(@"Should unstar the repo", ^AsyncBlock{
            __block BOOL calledGithubAPI=NO;
            [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
                if ([request.URL.host isEqualToString:@"api.github.com"]&&[request.URL.path isEqualToString:@"/user/starred/wycats/merb-core"] && [request.HTTPMethod isEqualToString:@"DELETE"])
                {
                    calledGithubAPI=YES;
                    return YES;
                }
                else
                {
                    return NO;
                }
            } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
                return [OHHTTPStubsResponse responseWithData:nil statusCode:204 headers:nil];
            }];
            [FISGithubAPIClient unstarRepoWithFullName:fullName
                                       CompletionBlock:^{
                                           done();
                                       }];
            expect(calledGithubAPI).will.beTruthy(); //Check that the correct request was sent
        });
    });
});

SpecEnd
