//
//  Header.h
//  Pods
//
//  Created by ozr on 17/3/13.
//
//

#ifndef _APNETWORK_
#define _APNETWORK_

#if __has_include(<APNetwork/APNetwork.h>)

#import <APNetwork/APBaseApiRequest.h>
#import <APNetwork/APNetworkProtocol.h>
#import <APNetwork/APBatchRequest.h>
#import <APNetwork/APDownloadImageRequest.h>
#import <APNetwork/APNetworkGlobalConfig.h>

#else

#import "APBaseApiRequest.h"
#import "APNetworkProtocol.h"
#import "APBatchRequest.h"
#import "APDownloadImageRequest.h"
#import "APNetworkGlobalConfig.h"

#endif /* __has_include */

#endif /* _APNETWORK_ */
