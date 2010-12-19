
#import <QTKit/QTKit.h>

#import "HotKey.h"
#import "Recorder.h"

@interface Global : NSObject
{
  HotKey *hkey;

@public
  Recorder *recorder;
  double fps;
  int width, height;

}
+ (Global *) sharedInstance;
@end

