
#import <Cocoa/Cocoa.h>
#import "MyDelegate.h"

@interface MyMenu : NSObject
@end

int main() {

  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  [NSApplication sharedApplication];

  id del = [[MyDelegation alloc] init];
  [NSApp setDelegate: del];

  MyMenu *menu = [[MyMenu alloc] init];

  [NSApp run];

  [pool release];
  return 0;
}
