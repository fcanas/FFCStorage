//
//  FFCStoreNullability.h
//  FFCStorage
//
//  Created by Fabian Canas on 4/12/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

#ifndef FFCStorage_FFCStoreNullability_h
#define FFCStorage_FFCStoreNullability_h


#if __has_feature(nullability)
#define FFC_ASSUME_NONNULL_BEGIN _Pragma("clang assume_nonnull begin")
#define FFC_ASSUME_NONNULL_END _Pragma("clang assume_nonnull end")
#define ffc_nullable nullable
#define ffc_nonnull nonnull
#define ffc_null_unspecified null_unspecified
#define ffc_null_resettable null_resettable
#define __ffc_nullable __nullable
#define __ffc_nonnull __nonnull
#define __ffc_null_unspecified __null_unspecified
#else
#define FFC_ASSUME_NONNULL_BEGIN
#define FFC_ASSUME_NONNULL_END
#define ffc_nullable
#define ffc_nonnull
#define ffc_null_unspecified
#define ffc_null_resettable
#define __ffc_nullable
#define __ffc_nonnull
#define __ffc_null_unspecified
#endif

#endif
