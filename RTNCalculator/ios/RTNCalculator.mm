#import "RTNCalculator.h"

#import <Security/Security.h>
#import <React/RCTConvert.h>
#import <React/RCTUtils.h>

@implementation RTNCalculator

RCT_EXPORT_MODULE(RTNCalculator)

- (void)add:(double)a b:(double)b resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    NSNumber *result = [[NSNumber alloc] initWithInteger:a+b+a];
    resolve(result);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeRTNCalculatorSpecJSI>(params);
}

- (void)setItem:(NSString*)key value:(NSString*)value options:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {

    NSString * keychainService = [RCTConvert NSString:options[@"keychainService"]];
    if (keychainService == NULL) {
        keychainService = @"app";
    }

    NSData* valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* search = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      (__bridge id)(kSecClassGenericPassword), kSecClass,
                                      keychainService, kSecAttrService,
                                      kSecAttrSynchronizableAny, kSecAttrSynchronizable,
                                      key, kSecAttrAccount, nil];
    NSMutableDictionary *query = [search mutableCopy];
    [query setValue: valueData forKey: kSecValueData];

    OSStatus osStatus;
    //
    // Instead of unconditionally deleting, try the add and if it fails with a duplicate item
    // error, try an update.
    //
    osStatus = SecItemAdd((__bridge CFDictionaryRef) query, NULL);
    if (osStatus == errSecSuccess) {
        resolve(value);
        return;
    }
    if (osStatus == errSecDuplicateItem) {
        NSDictionary *update = @{(__bridge id)kSecValueData:valueData};
        osStatus = SecItemUpdate((__bridge CFDictionaryRef)search,
                                 (__bridge CFDictionaryRef)update);
    }
    if (osStatus != noErr) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osStatus userInfo:nil];
        reject([NSString stringWithFormat:@"%ld",(long)error.code], [self messageForError:error], nil);
        return;
    }
    resolve(value);
}

- (void)getItem:(NSString *)key options:(NSDictionary *)options resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    NSString * keychainService = [RCTConvert NSString:options[@"keychainService"]];
    if (keychainService == NULL) {
        keychainService = @"app";
    }

    // Create dictionary of search parameters
    NSMutableDictionary* query = [NSMutableDictionary dictionaryWithObjectsAndKeys:(__bridge id)(kSecClassGenericPassword), kSecClass,
                                  keychainService, kSecAttrService,
                                  key, kSecAttrAccount,
                                  kSecAttrSynchronizableAny, kSecAttrSynchronizable,
                                  kCFBooleanTrue, kSecReturnAttributes,
                                  kCFBooleanTrue, kSecReturnData,
                                  nil];

    // Look up server in the keychain
    NSDictionary* found = nil;
    CFTypeRef foundTypeRef = NULL;
    OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef) query, (CFTypeRef*)&foundTypeRef);
    
    if (osStatus != noErr && osStatus != errSecItemNotFound) {
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain code:osStatus userInfo:nil];
        reject([NSString stringWithFormat:@"%ld",(long)error.code], [self messageForError:error], nil);
    }
    
    found = (__bridge NSDictionary*)(foundTypeRef);
    if (!found) {
        resolve(nil);
    } else {
        // Found
        NSString* value = [[NSString alloc] initWithData:[found objectForKey:(__bridge id)(kSecValueData)] encoding:NSUTF8StringEncoding];
        resolve(value);
    }
}

@end
