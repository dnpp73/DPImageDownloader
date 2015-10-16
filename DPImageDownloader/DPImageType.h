#ifndef DNPP_DPImageType_h
#define DNPP_DPImageType_h

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    #define DPImageType UIImage
#elif TARGET_OS_MAC
    #define DPImageType NSImage
#endif

#endif
