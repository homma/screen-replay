#import <QTKit/QTKit.h>

@interface Audio : NSObject
{

  QTCaptureSession *captureSession;
  QTCaptureDevice *captureDevice;
  QTCaptureDeviceInput *captureInput;
  QTCaptureMovieFileOutput *captureOutput;
  NSString *path;

}

- (id) init;
- (void) dealloc;
- (void) initialize;
- (void) createAudioPath;
- (NSString *) audioPath;
- (void) cleanUp;
- (void) start;
- (void) stop;

@end

