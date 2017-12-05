
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "strftime_ms.h"

size_t		strftime_ms(char* ptr,
			    size_t max,
			    const char* format,
			    const struct timeval* tv)
{
    const char	*seek_format;
    char	*seek_strftime_format;
    size_t	strftime_format_size;
    char	*strftime_format;
    struct tm	*tm;
    size_t	result;

    strftime_format_size = strlen(format);
    seek_format = format;
    while ((seek_format = strstr(seek_format, "%")) != NULL)
      {
	switch (seek_format[1])
	  {
	  case 'L':
	    strftime_format_size += 1;
	    break;
	  }
	seek_format += 2;
      }
    strftime_format = malloc(strftime_format_size + 1);
    if (strftime_format == NULL)
      return 0;
    seek_format = format;
    seek_strftime_format = strftime_format;
    while ((seek_format = strstr(format, "%")) != NULL)
      {
	memcpy(seek_strftime_format, format, seek_format - format);
	seek_strftime_format += seek_format - format;
	format = seek_format;
	switch (seek_format[1])
	  {
	  case 'L':
	    sprintf(seek_strftime_format, "%03ld", tv->tv_usec/1000);
	    seek_strftime_format += 3;
	    seek_format += 2;
	    format = seek_format;
	    break;
	  default:
	    memcpy(seek_strftime_format, format, 2);
	    seek_format += 2;
	    seek_strftime_format += seek_format - format;
	    format = seek_format;
	  }
      }
    memcpy(seek_strftime_format, format, strlen(format));
    seek_strftime_format[strlen(format)] = '\0';
    tm = localtime(&(tv->tv_sec));
    if(tm == NULL)
      {
	free(strftime_format);
	return 0;
      }
    result = strftime(ptr, max, strftime_format, tm);
    free(strftime_format);
    return result;
}
