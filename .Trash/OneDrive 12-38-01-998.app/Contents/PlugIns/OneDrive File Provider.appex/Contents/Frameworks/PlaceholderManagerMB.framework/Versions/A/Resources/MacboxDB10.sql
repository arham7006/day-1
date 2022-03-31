CREATE INDEX fsid_tombstoned_index on dbfs_files (fsid, tombstoned);
CREATE INDEX parentid_name_tombstoned_index on dbfs_files (parentid, name, tombstoned);
