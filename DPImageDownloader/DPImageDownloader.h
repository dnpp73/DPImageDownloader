#import "DPImageType.h"


typedef void(^DPImageDownloaderCompleteBlock)(DPImageType* image); // nil is failed. UIImage or NSImage


@interface DPImageDownloader : NSObject

+ (instancetype)sharedInstance;

- (DPImageType*)getImageWithURL:(NSString*)url
               useOnMemoryCache:(BOOL)useOnMemoryCache
                       lifeTime:(NSUInteger)lifeTime
                     completion:(DPImageDownloaderCompleteBlock)completion;

-  (DPImageType*)getImageWithURL:(NSString*)url
                useOnMemoryCache:(BOOL)useOnMemoryCache
                        lifeTime:(NSUInteger)lifeTime
feedbackNetworkActivityIndicator:(BOOL)feedbackNetworkActivityIndicator
                 completionQueue:(dispatch_queue_t)queue
                      completion:(DPImageDownloaderCompleteBlock)completion;

@end
