select * from cron.schedule('interest calculation','00 01 * * *', 'select * from job_calculate_interest(2);');
select * from cron.schedule('cyclical transactions process','00 02 * * *', 'select * from job_process_cyclical_transactions_service(2);');
select * from cron.schedule('ordered transactions process','00 12,15,18 * * *', 'select * from job_calculate_interest(2);');