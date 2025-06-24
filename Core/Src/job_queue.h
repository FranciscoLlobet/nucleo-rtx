/*
 * job_queue.h
 *
 *  Created on: Jun 22, 2025
 *      Author: Francisco
 */

#ifndef SRC_JOB_QUEUE_H_
#define SRC_JOB_QUEUE_H_

#include "cmsis_os2.h"


/* Job function pointer */
typedef void (* job_fn_t)(void *);

struct job_queue_ctrl_s
{
	osThreadId_t thread;
	osMessageQueueId_t job_queue;
};


typedef struct job_queue_ctrl_s * job_queue_t;

osStatus_t enqueue_job(job_queue_t job_queue, uint8_t job_prio, job_fn_t job_fn, void *job_arg);

osStatus_t init_job_queue(job_queue_t job_queue, const osThreadAttr_t * job_thread_attr);

#endif /* SRC_JOB_QUEUE_H_ */
