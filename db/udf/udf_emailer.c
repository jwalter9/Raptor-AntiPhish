/* 
	lib_mysqludf_emailer - a library for sending email
	Copyright (C) 2014 Jeff Walter 
	web: http://www.mysqludf.org/
	email: lowadobe@gmail.com
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.
	
	You should have received a copy of the GNU Lesser General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/
#if defined(_WIN32) || defined(_WIN64) || defined(__WIN32__) || defined(WIN32)
#define DLLEXP __declspec(dllexport) 
#else
#define DLLEXP
#endif

#ifdef STANDARD
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#ifdef __WIN__
typedef unsigned __int64 ulonglong;
typedef __int64 longlong;
#else
typedef unsigned long long ulonglong;
typedef long long longlong;
#endif /*__WIN__*/
#else
#include <my_global.h>
#include <my_sys.h>
#endif
#include <mysql.h>
#include <m_ctype.h>
#include <m_string.h>
#include <stdlib.h>

#include <ctype.h>

#include <libesmtp.h>

#ifdef HAVE_DLOPEN
#ifdef	__cplusplus
extern "C" {
#endif

#define LIBVERSION "lib_mysqludf_emailer version 0.0.1"

#ifdef __WIN__
#define SETENV(name,value)		SetEnvironmentVariable(name,value);
#else
#define SETENV(name,value)		setenv(name,value,1);		
#endif

DLLEXP 
my_bool emailer_init(
	UDF_INIT *initid
,	UDF_ARGS *args
,	char *message
);

DLLEXP 
void emailer_deinit(
	UDF_INIT *initid
);

DLLEXP 
my_ulonglong emailer(
	UDF_INIT *initid
,	UDF_ARGS *args
,	char *is_null
,	char *error
);

#ifdef	__cplusplus
}
#endif


my_bool emailer_init(
	UDF_INIT *initid
,	UDF_ARGS *args
,	char *message
){
	if(args->arg_count == 4
	&& args->arg_type[0]==STRING_RESULT
	&& args->arg_type[1]==STRING_RESULT
	&& args->arg_type[2]==STRING_RESULT
	&& args->arg_type[3]==STRING_RESULT){
		return 0;
	} else {
		strcpy(
			message,"Expected 4 parameters: from, to, [server:port], and the email content"
		);		
		return 1;
	}
}
void emailer_deinit(
	UDF_INIT *initid
){
}
my_ulonglong emailer(
	UDF_INIT *initid
,	UDF_ARGS *args
,	char *is_null
,	char *error
){
	smtp_session_t session;
	smtp_message_t message;
	session = smtp_create_session();
	message = smtp_add_message(session);
	smtp_add_recipient(message, args->args[1]);
	struct sigaction sa;
	sa.sa_handler = SIG_IGN;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	sigaction(SIGPIPE, &sa, NULL); 
	smtp_set_server(session, args->args[2]);
	smtp_set_reverse_path(message, args->args[0]);
	smtp_set_message_str(message, args->args[3]);
	if (!smtp_start_session(session)){
		long err;
		err = smtp_errno();
		smtp_destroy_session(session);
		return err;
	};
	smtp_destroy_session(session);
	return 0;
}

#endif /* HAVE_DLOPEN */
