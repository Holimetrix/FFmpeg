#ifndef STRFTIME_MS_H_
# define STRFTIME_MS_H_

# include <time.h>
# include <sys/time.h>

size_t      strftime_ms(char* ptr,
                        size_t maxsize,
                        const char* format,
                        const struct timeval* tv);

#endif /* !STRFTIME_MS_H_ */
