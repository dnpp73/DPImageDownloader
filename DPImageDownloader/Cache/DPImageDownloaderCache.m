#import "DPImageDownloaderCache.h"


@interface DPImageDownloaderCache ()
{
    DPImageType* _image;
}

@property (nonatomic, copy)     NSString*      key;
@property (nonatomic)           NSTimeInterval createdAt;
@property (nonatomic, copy)     NSData*        data;

@end


@implementation DPImageDownloaderCache

+ (instancetype)cacheWithData:(NSData*)data key:(NSString*)key
{
    if (!data) {
        return nil;
    }
    
    DPImageDownloaderCache* cache = [[self alloc] init];
    if (!cache) {
        return nil;
    }
    
    cache.createdAt = time(NULL);
    cache.data = data;
    cache.key = key;
    return cache;
}

+ (instancetype)cacheFromStorageWithKey:(NSString*)key usingFileManager:(NSFileManager*)fm;
{
    NSData* data = [NSData dataWithContentsOfFile:[[self cacheDirectoryPath] stringByAppendingPathComponent:key]];
    DPImageDownloaderCache* cache = [self cacheWithData:data key:key];
    if (!cache) {
        return nil;
    }
    cache.createdAt = [[fm attributesOfItemAtPath:[[self cacheDirectoryPath] stringByAppendingPathComponent:key] error:nil] fileCreationDate].timeIntervalSince1970;
    return cache;
}

- (DPImageType*)image
{
    if (_image) {
        return _image;
    }
    else {
        return [[DPImageType alloc] initWithData:_data];
    }
}

- (BOOL)isExpiredWith:(NSTimeInterval)time lifeTime:(NSTimeInterval)lifeTime
{
    if ((NSTimeInterval)(fabs((double)time - (double)_createdAt)) > lifeTime) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)save
{
    NSString* path = [[self class] cacheDirectoryPath];
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if ([fm fileExistsAtPath:path isDirectory:&isDirectory]) {
        if (!isDirectory) {
            [fm removeItemAtPath:path error:nil];
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    } else {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [_data writeToFile:[path stringByAppendingPathComponent:_key] atomically:NO];
}

- (void)deleteUsingFileManager:(NSFileManager*)fm
{
    [fm removeItemAtPath:[[[self class] cacheDirectoryPath] stringByAppendingPathComponent:_key] error:nil];
}

+ (NSString*)cacheDirectoryPath
{
    NSArray*  cachePaths     = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cacheDirectory = [cachePaths[0] stringByAppendingPathComponent:@"org.dnpp73.library.DPImageDownloader"];
    return cacheDirectory;
}

@end
