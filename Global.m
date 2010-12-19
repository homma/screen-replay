/*
 * a singleton object to store globally accessible objects
 */

#import <Cocoa/Cocoa.h>
#import "Global.h"

@implementation Global

static Global *instance = NULL;

+ (Global *) sharedInstance{
  return instance;
}

@end

///////// Private methods //////////

@interface Global (Private)
+ (void) initialize;
@end

@implementation Global (Private)

+ (void) initialize
{
  instance = [[Global alloc] init];
  // NSLog(@"Global object initialized.");
}

- (id) init
{
  self = [super init];
  if (self) {

    fps = 0.66;
    width = 640;
    height = 480;
    hkey = [[HotKey alloc] init];
    recorder = [[Recorder alloc] init];

  }
  return self;
}

- (void) dealloc
{

  [hkey release];
  [recorder release];

  [super dealloc];
}

@end

