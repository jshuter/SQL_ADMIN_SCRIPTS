use smtr_staging 

select top 100 l.id, p.id, t.id, l.* from smtr_staging.SRC.FileTypeProcessorLog l
join SRC.FileTypeProcessor p on p.Id = FileTypeProcessorId 
join SRC.FileTypeNew t on t.Id = p.FileTypeId
where t.name = 'Custody Valuation' 
order by l.ProcessedDate desc 
