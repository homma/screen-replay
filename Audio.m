#import <Cocoa/Cocoa.h>
#import "Audio.h"

@implementation Audio

- (id) init
{

  self = [super init];

  if(self) {

    [self initialize];

  }

  return self;

}

- (void) dealloc
{
  [captureOutput release];
  [captureInput release];
  [captureSession release];

  [super dealloc];

}

- (void) initialize
{

  NSError *err;
  err = NULL;
  QTCompressionOptions *opt;
  QTCaptureConnection *conn;

  captureSession = [[QTCaptureSession alloc] init];
  captureDevice = [QTCaptureDevice
                     defaultInputDeviceWithMediaType: QTMediaTypeSound];
  [captureDevice open: &err];
  if(err) NSLog(@"caputure device error: %@", err);
  err = NULL;

  captureInput = [[QTCaptureDeviceInput alloc] initWithDevice: captureDevice];
  [captureSession addInput: captureInput error: &err];
  if(err) NSLog(@"caputure device error: %@", err);
  err = NULL;

  captureOutput = [[QTCaptureMovieFileOutput alloc] init];
  [captureSession addOutput: captureOutput error: &err];
  if(err) NSLog(@"caputure device error: %@", err);
  err = NULL;

  opt = [QTCompressionOptions
          compressionOptionsWithIdentifier:
            @"QTCompressionOptionsVoiceQualityAACAudio"];
  conn = [[captureOutput connections] objectAtIndex: 0];

  [captureOutput setCompressionOptions: opt forConnection: conn];

  [self createAudioPath];

}

- (void) createAudioPath
{

  // Audio Output
  path = [NSTemporaryDirectory()
            stringByAppendingPathComponent: @"audio.mov"];
  [path retain];

}

- (void) cleanUp
{

  // remove audio file
  NSError *err;
  err = NULL;
  [[NSFileManager defaultManager] removeItemAtPath: path error: &err];
  if(err) NSLog(@"audio remove error : %@", err); err = NULL;

  // NSLog(@"audio cleanup done.");
}

- (NSString *) audioPath
{

  return path;

}

- (void) start;
{
  NSURL *url;

  url = [NSURL fileURLWithPath: path];

  [captureOutput recordToOutputFileURL: url];
  [captureSession startRunning];

}

- (void) stop
{

  [captureSession stopRunning];
  [captureDevice close];
  [captureOutput recordToOutputFileURL: nil];

}

@end

