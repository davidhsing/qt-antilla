#pragma once

#if !defined(BUILD_ANTILLA_STATIC_LIBRARY)
#  if defined(BUILD_ANTILLA_LIB)
#    define ANTILLA_EXPORT Q_DECL_EXPORT
#  else
#    define ANTILLA_EXPORT Q_DECL_IMPORT
#  endif
#else
#  define ANTILLA_EXPORT
#endif
