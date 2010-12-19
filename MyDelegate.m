
#import <Cocoa/Cocoa.h>
#import "Global.h"
#import "MyDelegate.h"

@implementation MyDelegation : NSObject

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
//  initialize application

  [Global sharedInstance];    // initializing

}

- (void) applicationWillTerminate:(NSNotification *)aNotification {
//  clear application

  [[Global sharedInstance] release];

}

@end

