
#import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

#import "Global.h"
#import "HotKey.h"

static EventHotKeyRef startRef;
static EventHotKeyRef stopRef;

@implementation HotKey

- (id) init {

  self = [super init];
  if (self) {

    [self registerHotKey];

  }
  return self;

}

- (void) dealloc {

  [self unregisterHotKey];

  [super dealloc];

}

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef theEvent,
                       void *userData) {

  EventHotKeyID id;
  GetEventParameter( theEvent, kEventParamDirectObject, typeEventHotKeyID,
                     NULL, sizeof(id), NULL, &id);

  if(id.id == 1) {
    NSLog(@"start recording!");

    // start recording
    [ ([Global sharedInstance])->recorder start];

  } else if(id.id == 2) {
    NSLog(@"stop recording!");

    // stop recording
    [ ([Global sharedInstance])->recorder stop];

  }

  return noErr;

}

- (void) registerHotKey {

  EventTypeSpec list[] = {
    { kEventClassKeyboard, kEventHotKeyPressed }
  };

  ItemCount i = GetEventTypeCount(list);

  InstallApplicationEventHandler( &hotKeyHandler, i, list, NULL, NULL);

  EventHotKeyID id;
  UInt32 code;
  UInt32 modifier;
  EventTargetRef target;
  OptionBits opt;

  // start hotkey
  code = 15;  // keycode of 'R'
  modifier = cmdKey + shiftKey;
  id.id = 1;
  id.signature = 'htk1';
  target = GetApplicationEventTarget();
  opt = 0;

  RegisterEventHotKey( code, modifier, id, target, opt, &startRef);

  // stop hotkey
  code = 13;  // keycode of 'W'
  id.id = 2;
  id.signature = 'htk2';

  RegisterEventHotKey( code, modifier, id, target, opt, &stopRef);

}

- (void) unregisterHotKey {

  UnregisterEventHotKey(startRef);
  UnregisterEventHotKey(stopRef);

}

@end
