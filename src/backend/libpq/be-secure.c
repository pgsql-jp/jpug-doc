/*-------------------------------------------------------------------------
 *
 * be-secure.c
 *	  functions related to setting up a secure connection to the frontend.
 *	  Secure connections are expected to provide confidentiality,
 *	  message integrity and endpoint authentication.
 *
 *
 * Portions Copyright (c) 1996-2014, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 *
 * IDENTIFICATION
 *	  src/backend/libpq/be-secure.c
 *
 *-------------------------------------------------------------------------
 */

#include "postgres.h"

#include <sys/stat.h>
#include <signal.h>
#include <fcntl.h>
#include <ctype.h>
#include <sys/socket.h>
#include <unistd.h>
#include <netdb.h>
#include <netinet/in.h>
#ifdef HAVE_NETINET_TCP_H
#include <netinet/tcp.h>
#include <arpa/inet.h>
#endif

#include "libpq/libpq.h"
#include "tcop/tcopprot.h"
#include "utils/memutils.h"


char	   *ssl_cert_file;
char	   *ssl_key_file;
char	   *ssl_ca_file;
char	   *ssl_crl_file;

/*
 *	How much data can be sent across a secure connection
 *	(total in both directions) before we require renegotiation.
 *	Set to 0 to disable renegotiation completely.
 */
int			ssl_renegotiation_limit;

#ifdef USE_SSL
bool ssl_loaded_verify_locations = false;
#endif

/* GUC variable controlling SSL cipher list */
char	   *SSLCipherSuites = NULL;

/* GUC variable for default ECHD curve. */
char	   *SSLECDHCurve;

/* GUC variable: if false, prefer client ciphers */
bool		SSLPreferServerCiphers;

/* ------------------------------------------------------------ */
/*			 Procedures common to all secure sessions			*/
/* ------------------------------------------------------------ */

/*
 *	Initialize global context
 */
int
secure_initialize(void)
{
#ifdef USE_SSL
	be_tls_init();
#endif

	return 0;
}

/*
 * Indicate if we have loaded the root CA store to verify certificates
 */
bool
secure_loaded_verify_locations(void)
{
#ifdef USE_SSL
	return ssl_loaded_verify_locations;
#else
	return false;
#endif
}

/*
 *	Attempt to negotiate secure session.
 */
int
secure_open_server(Port *port)
{
	int			r = 0;

#ifdef USE_SSL
	r = be_tls_open_server(port);
#endif

	return r;
}

/*
 *	Close secure session.
 */
void
secure_close(Port *port)
{
#ifdef USE_SSL
	if (port->ssl_in_use)
		be_tls_close(port);
#endif
}

/*
 *	Read data from a secure connection.
 */
ssize_t
secure_read(Port *port, void *ptr, size_t len)
{
	ssize_t		n;

#ifdef USE_SSL
	if (port->ssl_in_use)
	{
		n = be_tls_read(port, ptr, len);
	}
	else
#endif
	{
		n = secure_raw_read(port, ptr, len);
	}

	return n;
}

ssize_t
secure_raw_read(Port *port, void *ptr, size_t len)
{
	ssize_t		n;

<<<<<<< HEAD
=======
#ifdef USE_SSL
	if (port->ssl)
	{
		int			err;

		/*
		 * If SSL renegotiations are enabled and we're getting close to the
		 * limit, start one now; but avoid it if there's one already in
		 * progress.  Request the renegotiation 1kB before the limit has
		 * actually expired.
		 */
		if (ssl_renegotiation_limit && !in_ssl_renegotiation &&
			port->count > (ssl_renegotiation_limit - 1) * 1024L)
		{
			in_ssl_renegotiation = true;

			/*
			 * The way we determine that a renegotiation has completed is by
			 * observing OpenSSL's internal renegotiation counter.  Make sure
			 * we start out at zero, and assume that the renegotiation is
			 * complete when the counter advances.
			 *
			 * OpenSSL provides SSL_renegotiation_pending(), but this doesn't
			 * seem to work in testing.
			 */
			SSL_clear_num_renegotiations(port->ssl);

			SSL_set_session_id_context(port->ssl, (void *) &SSL_context,
									   sizeof(SSL_context));
			if (SSL_renegotiate(port->ssl) <= 0)
				ereport(COMMERROR,
						(errcode(ERRCODE_PROTOCOL_VIOLATION),
						 errmsg("SSL failure during renegotiation start")));
			else
			{
				int			retries;

				/*
				 * A handshake can fail, so be prepared to retry it, but only
				 * a few times.
				 */
				for (retries = 0;; retries++)
				{
					if (SSL_do_handshake(port->ssl) > 0)
						break;	/* done */
					ereport(COMMERROR,
							(errcode(ERRCODE_PROTOCOL_VIOLATION),
							 errmsg("SSL handshake failure on renegotiation, retrying")));
					if (retries >= 20)
						ereport(FATAL,
								(errcode(ERRCODE_PROTOCOL_VIOLATION),
								 errmsg("could not complete SSL handshake on renegotiation, too many failures")));
				}
			}
		}

wloop:
		errno = 0;
		n = SSL_write(port->ssl, ptr, len);
		err = SSL_get_error(port->ssl, n);
		switch (err)
		{
			case SSL_ERROR_NONE:
				port->count += n;
				break;
			case SSL_ERROR_WANT_READ:
			case SSL_ERROR_WANT_WRITE:
#ifdef WIN32
				pgwin32_waitforsinglesocket(SSL_get_fd(port->ssl),
											(err == SSL_ERROR_WANT_READ) ?
									FD_READ | FD_CLOSE : FD_WRITE | FD_CLOSE,
											INFINITE);
#endif
				goto wloop;
			case SSL_ERROR_SYSCALL:
				/* leave it to caller to ereport the value of errno */
				if (n != -1)
				{
					errno = ECONNRESET;
					n = -1;
				}
				break;
			case SSL_ERROR_SSL:
				ereport(COMMERROR,
						(errcode(ERRCODE_PROTOCOL_VIOLATION),
						 errmsg("SSL error: %s", SSLerrmessage())));
				/* fall through */
			case SSL_ERROR_ZERO_RETURN:
				errno = ECONNRESET;
				n = -1;
				break;
			default:
				ereport(COMMERROR,
						(errcode(ERRCODE_PROTOCOL_VIOLATION),
						 errmsg("unrecognized SSL error code: %d",
								err)));
				errno = ECONNRESET;
				n = -1;
				break;
		}

		if (n >= 0)
		{
			/* is renegotiation complete? */
			if (in_ssl_renegotiation &&
				SSL_num_renegotiations(port->ssl) >= 1)
			{
				in_ssl_renegotiation = false;
				port->count = 0;
			}

			/*
			 * if renegotiation is still ongoing, and we've gone beyond the
			 * limit, kill the connection now -- continuing to use it can be
			 * considered a security problem.
			 */
			if (in_ssl_renegotiation &&
				port->count > ssl_renegotiation_limit * 1024L)
				ereport(FATAL,
						(errcode(ERRCODE_PROTOCOL_VIOLATION),
						 errmsg("SSL failed to renegotiate connection before limit expired")));
		}
	}
	else
#endif
		n = send(port->sock, ptr, len, 0);

	return n;
}

/* ------------------------------------------------------------ */
/*						  SSL specific code						*/
/* ------------------------------------------------------------ */
#ifdef USE_SSL

/*
 * Private substitute BIO: this does the sending and receiving using send() and
 * recv() instead. This is so that we can enable and disable interrupts
 * just while calling recv(). We cannot have interrupts occurring while
 * the bulk of openssl runs, because it uses malloc() and possibly other
 * non-reentrant libc facilities. We also need to call send() and recv()
 * directly so it gets passed through the socket/signals layer on Win32.
 *
 * These functions are closely modelled on the standard socket BIO in OpenSSL;
 * see sock_read() and sock_write() in OpenSSL's crypto/bio/bss_sock.c.
 * XXX OpenSSL 1.0.1e considers many more errcodes than just EINTR as reasons
 * to retry; do we need to adopt their logic for that?
 */

static bool my_bio_initialized = false;
static BIO_METHOD my_bio_methods;

static int
my_sock_read(BIO *h, char *buf, int size)
{
	int			res = 0;

>>>>>>> doc_ja_9_4
	prepare_for_client_read();

	n = recv(port->sock, ptr, len, 0);

	client_read_ended();

	return n;
}


/*
 *	Write data to a secure connection.
 */
ssize_t
secure_write(Port *port, void *ptr, size_t len)
{
	ssize_t		n;

#ifdef USE_SSL
	if (port->ssl_in_use)
	{
		n = be_tls_write(port, ptr, len);
	}
	else
#endif
		n = secure_raw_write(port, ptr, len);

	return n;
}

ssize_t
secure_raw_write(Port *port, const void *ptr, size_t len)
{
	return send(port->sock, ptr, len, 0);
}
