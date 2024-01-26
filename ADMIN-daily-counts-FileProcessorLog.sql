use smtr_staging 


select top 1000 * from SRC.FileTypeProcessorLog 
where cast(ProcessedDate as date) = cast(getdate() as date) 
order by ProcessedDate desc 

select top 1000 * from SRC.FileTypeProcessorLog 
where cast(ProcessedDate as date) = dateadd(D, -1, cast(getdate() as date)) 
order by ProcessedDate desc 

select top 1000 * from SRC.FileTypeProcessorLog 
where cast(ProcessedDate as date) = dateadd(D, -2, cast(getdate() as date)) 
order by ProcessedDate desc 

select top 1000 * from SRC.FileTypeProcessorLog 
where cast(ProcessedDate as date) = dateadd(D, -3, cast(getdate() as date)) 
order by ProcessedDate desc 

select top 1000 * from SRC.FileTypeProcessorLog 
where cast(ProcessedDate as date) = dateadd(D, -4, cast(getdate() as date)) 
order by ProcessedDate desc 

select top 1000 * from SRC.FileTypeProcessorLog 
where cast(ProcessedDate as date) = dateadd(D, -5, cast(getdate() as date)) 
order by ProcessedDate desc 

select top 1000 * from SRC.FileTypeProcessorLog 
where cast(ProcessedDate as date) = dateadd(D, -6, cast(getdate() as date)) 
order by ProcessedDate desc 

select top 1000 * from SRC.FileTypeProcessorLog 
where cast(ProcessedDate as date) = dateadd(D, -7, cast(getdate() as date)) 
order by ProcessedDate desc 
