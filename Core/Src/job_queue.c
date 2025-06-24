#include "job_queue.h"

/* Job message queue element */
struct job_s
{
	job_fn_t fn;
	void *arg;
};

typedef struct job_s job_t;


osStatus_t enqueue_job(job_queue_t job_queue, uint8_t job_prio, job_fn_t job_fn, void *job_arg)
{
	osStatus_t status = osOK;

	job_t job = {.fn = job_fn, .arg = job_arg};

	if(osOK == status)
	{
		status = osMessageQueuePut(job_queue->job_queue, &job, job_prio, 0);
	}

	return status;
}

void job_queue_executor(const job_queue_t job_queue)
{
	job_t job;
	uint8_t prio = 0;

	for (;;)
	{
		osStatus_t status = osMessageQueueGet(job_queue->job_queue, &job, &prio, osWaitForever);
		if (status == osOK)
		{
			if (job.fn != NULL){
				job.fn(job.arg);
			}
		}
	}
}


osStatus_t init_job_queue(job_queue_t job_queue, const osThreadAttr_t * job_thread_attr)
{
	osStatus_t status = osOK;

	osMessageQueueAttr_t queueAttr = {.name = "queue", .attr_bits = osSafetyClass(0), .cb_mem = NULL, .cb_size = 0};

	job_queue->job_queue = osMessageQueueNew(1, sizeof(struct job_s), &queueAttr);

	job_queue->thread = osThreadNew ((osThreadFunc_t)job_queue_executor, job_queue, job_thread_attr);



	return status;
}
