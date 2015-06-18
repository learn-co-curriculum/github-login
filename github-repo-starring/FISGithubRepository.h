//
//  FISGithubRepository.h
//  ReviewSession 3-16-14
//
//  Created by Joe Burgess on 3/16/14.
//  Copyright (c) 2014 Joe Burgess. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class to represent a repository from Github.
 */
@interface FISGithubRepository : NSObject

///---------------------
/// @name Properties
///---------------------

/**
*  `NSString` full name of repository. Comes from the "full_name" key
*/
@property (strong, nonatomic) NSString *fullName;

/**
 *  `NSURL` html URL of repository. Comes from the "html_url" key
 */
@property (strong, nonatomic) NSURL *htmlURL;

/**
 *  `NSString` repository ID. Comes from the "id" key
 */
@property (strong, nonatomic) NSString *repositoryID;

+(FISGithubRepository *)repoFromDictionary:(NSDictionary *)repoDictionary;
@end
