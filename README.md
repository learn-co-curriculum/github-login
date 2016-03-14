# GitHub Login

## Introduction

Our previous GitHub Starring app was hard-coded to be logged in as you - obviously that's not ideal. Let's implement OAuth for this app so that it can authenticate any user who logs into the app using Github.

Instead of providing a personal access token (which you have manually provided to the constants file) that allowed us to star/unstar repos, we are going to generate an OAuth access token from within the app (which you will create below). Github describes personal access tokens as follows: “Personal access tokens function like ordinary OAuth access tokens. They can be used instead of a password for Git over HTTPS, or can be used to authenticate to the API over Basic Authentication." This works well for personal uses; however, if we were to ship an app, we wouldn’t want to include our personal access token for every user to use. We want each individual to retrieve their own OAuth token to allow them to star/unstar repos. They can accomplish this by logging in to GitHub *within our app* using their GitHub username and password.

## The Constants File

We've gone ahead and brought in code that fetches the list of public repositories from Github and displays it in a table view. To get that code working, you'll need to fill the `FISConstants.m` file with your client ID, client secret, and personal access token, in a format like this:

```objc
NSString *const GITHUB_CLIENT_ID = @"your app ID";
NSString *const GITHUB_CLIENT_SECRET = @"your app secret";
NSString *const GITHUB_AUTH_TOKEN = @"your personal access token";
```

This is how the exising API client builds URLs for talking to the API; check out the API client to see the details. It's good practice to put your constants into one file like this so they can be changed easily and not committed to Git.

Once you've set up your constants `.m` file, run the app to make sure that the table view is being populated correctly and that you are able to star and unstar repositories.

## Instructions

  1. In your `FISGithubAPIClient.m` file, remove this line: `[serializer setAuthorizationHeaderFieldWithUsername:GITHUB_ACCESS_TOKEN password:@""];` from the following 3 methods: ```+(void)checkIfRepoIsStarredWithFullName:(NSString *)fullName
                        completionBlock:(void (^)(BOOL))completionBlock ```, ```+(void)starRepoWithFullName:(NSString *)fullName
            completionBlock:(void (^)(void))completionBlock ```, and ```+(void)unstarRepoWithFullName:(NSString *)fullName
              completionBlock:(void (^)(void))completionBlock```. If you run the app after doing this and attempt to star a repository, any requests will return a 401 Unauthorized Error. This happens because we just removed the authentication that the personal access token granted us. The goal is to have the user log in using their GitHub username and password in order to authenticate themselves.
  2. Create a new view controller called `FISGithubLoginViewController`. This view controller should have one UIButton on it with the title "Login with GitHub".
  3. In the `viewDidLoad` of `FISReposTableViewController`, present `FISGithubLoginViewController` modally.
  4. When a user taps on the "Login with GitHub" button, it should direct them to the appropriate GitHub login page. The URL should look something like this: `https://github.com/login/oauth/authorize?client_id=YOUR_CLIENT_ID&scope=public_repo`. For more information on how this URL was built, see the [GitHub OAuth page](https://developer.github.com/v3/oauth/#web-application-flow).
  5. Set up the url scheme in your app to receive the callback. Follow these screenshots to see how to do that: ![On Github](http://i.imgur.com/yvjkOEr.png "On GitHub")
  
  ^This is on the settings page of the OAuth application that you set up.
  
  ![In XCode](http://i.imgur.com/X6UcyOr.png "In XCode") - How to get here: Click your project file at the top of your project navigator. Then click on the name of your project under the "Targets" section in the left pane. With your project selected, choose the "Info" tab on the top of the screen. Scrool down to the "URL Types" section of this window.

  6. Handle the code that comes back from GitHub. [This handy category on NSURL](https://gist.github.com/misterfifths/74bc068167bf8f8a2464) will help you out. Create a category on NSURL called `QueryStrings` and fill the files out with the code from the GitHub link above. Follow the following screenshots for more information on how to create a category: 

![New File](http://i.imgur.com/EF8rL7w.png)
![Category](http://i.imgur.com/ZR9Wuxg.png)
  7. Request the auth token.
  8. Now do all the requests with your new found Auth Token!

  

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/github-login'>GitHub Login (OAuth)</a> on Learn.co and start learning to code for free.</p>
