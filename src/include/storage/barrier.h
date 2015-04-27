/*-------------------------------------------------------------------------
 *
 * barrier.h
 *	  Memory barrier operations.
 *
 * Portions Copyright (c) 1996-2014, PostgreSQL Global Development Group
 * Portions Copyright (c) 1994, Regents of the University of California
 *
 * src/include/storage/barrier.h
 *
 *-------------------------------------------------------------------------
 */
#ifndef BARRIER_H
#define BARRIER_H

<<<<<<< HEAD
=======
#include "storage/s_lock.h"

extern slock_t dummy_spinlock;

/*
 * A compiler barrier need not (and preferably should not) emit any actual
 * machine code, but must act as an optimization fence: the compiler must not
 * reorder loads or stores to main memory around the barrier.  However, the
 * CPU may still reorder loads or stores at runtime, if the architecture's
 * memory model permits this.
 *
 * A memory barrier must act as a compiler barrier, and in addition must
 * guarantee that all loads and stores issued prior to the barrier are
 * completed before any loads or stores issued after the barrier.  Unless
 * loads and stores are totally ordered (which is not the case on most
 * architectures) this requires issuing some sort of memory fencing
 * instruction.
 *
 * A read barrier must act as a compiler barrier, and in addition must
 * guarantee that any loads issued prior to the barrier are completed before
 * any loads issued after the barrier.  Similarly, a write barrier acts
 * as a compiler barrier, and also orders stores.  Read and write barriers
 * are thus weaker than a full memory barrier, but stronger than a compiler
 * barrier.  In practice, on machines with strong memory ordering, read and
 * write barriers may require nothing more than a compiler barrier.
 *
 * For an introduction to using memory barriers within the PostgreSQL backend,
 * see src/backend/storage/lmgr/README.barrier
 */

#if defined(DISABLE_BARRIERS)

/*
 * Fall through to the spinlock-based implementation.
 */
#elif defined(__INTEL_COMPILER)

/*
 * icc defines __GNUC__, but doesn't support gcc's inline asm syntax
 */
#if defined(__ia64__) || defined(__ia64)
#define pg_memory_barrier()		__mf()
#elif defined(__i386__) || defined(__x86_64__)
#define pg_memory_barrier()		_mm_mfence()
#endif

#define pg_compiler_barrier()	__memory_barrier()
#elif defined(__GNUC__)

/* This works on any architecture, since it's only talking to GCC itself. */
#define pg_compiler_barrier()	__asm__ __volatile__("" : : : "memory")

#if defined(__i386__)

/*
 * i386 does not allow loads to be reordered with other loads, or stores to be
 * reordered with other stores, but a load can be performed before a subsequent
 * store.
 *
 * "lock; addl" has worked for longer than "mfence".
 */
#define pg_memory_barrier()		\
	__asm__ __volatile__ ("lock; addl $0,0(%%esp)" : : : "memory", "cc")
#define pg_read_barrier()		pg_compiler_barrier()
#define pg_write_barrier()		pg_compiler_barrier()
#elif defined(__x86_64__)		/* 64 bit x86 */

/*
 * x86_64 has similar ordering characteristics to i386.
 *
 * Technically, some x86-ish chips support uncached memory access and/or
 * special instructions that are weakly ordered.  In those cases we'd need
 * the read and write barriers to be lfence and sfence.  But since we don't
 * do those things, a compiler barrier should be enough.
 */
#define pg_memory_barrier()		\
	__asm__ __volatile__ ("lock; addl $0,0(%%rsp)" : : : "memory", "cc")
#define pg_read_barrier()		pg_compiler_barrier()
#define pg_write_barrier()		pg_compiler_barrier()
#elif defined(__ia64__) || defined(__ia64)

/*
 * Itanium is weakly ordered, so read and write barriers require a full
 * fence.
 */
#define pg_memory_barrier()		__asm__ __volatile__ ("mf" : : : "memory")
#elif defined(__ppc__) || defined(__powerpc__) || defined(__ppc64__) || defined(__powerpc64__)

>>>>>>> doc_ja_9_4
/*
 * This used to be a separate file, full of compiler/architecture
 * dependent defines, but it's not included in the atomics.h
 * infrastructure and just kept for backward compatibility.
 */
#include "port/atomics.h"

#endif   /* BARRIER_H */
