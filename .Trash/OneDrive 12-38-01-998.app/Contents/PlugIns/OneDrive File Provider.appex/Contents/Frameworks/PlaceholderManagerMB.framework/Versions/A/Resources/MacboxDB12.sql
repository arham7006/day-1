DROP INDEX fsid_index;
DROP INDEX parentid_index;
CREATE INDEX tombstoned_index on dbfs_files (tombstoned);
