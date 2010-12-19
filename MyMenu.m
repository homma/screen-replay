
#import <Cocoa/Cocoa.h>

@interface MyMenu : NSObject
- (id) init;
- (void) initialize;
- (void) createMainMenu;
@end

@implementation MyMenu

- (id) init
{
  self = [super init];
  if (self) {

    [self initialize];

  }
  return self;
}

- (void) initialize {

  [self createMainMenu];

}

- (void) createMainMenu {

  // menuBar -> appMenuSlot -> appMenu
  NSMenu *menuBar;
  NSMenuItem *appMenuSlot;
  NSMenu *appMenu;

  [NSApp setMainMenu: [[NSMenu alloc] init]];
  menuBar = [NSApp mainMenu];

  appMenuSlot = [[NSMenuItem alloc] initWithTitle: @""
                                    action: nil
                                    keyEquivalent: @""];

  appMenu = [[NSMenu alloc] initWithTitle: @""];
  [appMenu addItemWithTitle: @"Quit"
           action: @selector(terminate:)
           keyEquivalent: @"q"];

  [appMenuSlot setSubmenu: appMenu];
  [menuBar addItem: appMenuSlot];

  [NSApp performSelector:@selector(setAppleMenu:) withObject: appMenu];

  [appMenu release];
  [appMenuSlot release];

}

@end
