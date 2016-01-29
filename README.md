

# Github Login

Our previous Github Starring  app was hard-coded to be logged in as you. Obviously that's not great. Let's implement an authentication.

## Instructions

  1. First step. Let's remove the Authentication line from the request serialization lines. Once we do this, you'll notice that all of the starring requests will return a (401) Unauthorized error. This is the sign that your authentication isn't correct! So lets create a new View Controller that has one button on it that says "login with Github". 
  2. On `viewDidLoad` of the Table View Controller display our new View Controller modally.
  3. When a user taps on the button it should redirect them to the appropriate github login page.
  4. Set up the url scheme in your app to receive the callback
  5. Handle the code back from github. [This CocoaPod](https://github.com/ginrou/NSURL-QueryParser) will help you out.
  6. Request the auth token.
  7. Store the auth token in `NSUserDefaults`
  8. Now do all the requests with your new found Auth Token!

## Bonus

  1. Handle the case if the token is revoked. Remember, the only way you know fi the token was revoked is if you get a 401 error.

<p data-visibility='hidden'>View <a href='https://learn.co/lessons/github-login' title='Github Login'>Github Login</a> on Learn.co and start learning to code for free.</p>
