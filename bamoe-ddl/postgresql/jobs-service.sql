--
-- It contains all the required Table to correctly manage and persist Job Instances
--

-- TABLE job_details: Represents a Job Instance on the Job Service with its details
CREATE TABLE job_details (
    id character varying(50) NOT NULL, -- the unique id internally on the job service
    correlation_id character varying(50), -- the job id on the runtimes,
    status character varying(40), -- the job status: 'ERROR' or 'EXECUTED' or 'SCHEDULED' or 'RETRY' or 'CANCELED'
    last_update timestamp with time zone,
    retries integer,
    execution_counter integer, -- number of times the job was executed
    scheduled_id character varying(40), -- the execution control on the scheduler (id on vertx.setTimer, quartzId...)
    priority integer,
    recipient jsonb, -- http callback, event topic
    trigger jsonb, -- when/how it should be executed
    fire_time timestamp with time zone,
    execution_timeout bigint,
    execution_timeout_unit character varying(40),
    created timestamp with time zone
);

-- TABLE job_service_management: used for clustering and to check lead instance
CREATE TABLE job_service_management (
    id character varying(40) NOT NULL,
    last_heartbeat timestamp with time zone,
    token character varying(40)
);

ALTER TABLE ONLY job_details
    ADD CONSTRAINT job_details_pkey1 PRIMARY KEY (id);

ALTER TABLE ONLY job_service_management
    ADD CONSTRAINT job_service_management_pkey PRIMARY KEY (id);

ALTER TABLE ONLY job_service_management
    ADD CONSTRAINT job_service_management_token_key UNIQUE (token);

CREATE INDEX job_details_created_idx ON job_details USING btree (created);

CREATE INDEX job_details_fire_time_idx ON job_details USING btree (fire_time);
