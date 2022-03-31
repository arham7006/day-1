DROP INDEX tombstoned_index;
CREATE INDEX tagid_index on dbfs_files (tagid);
CREATE INDEX parentid_anchor_tombstoned_index on dbfs_files (parentid, anchor, tombstoned);
CREATE INDEX marked_tombstoned_index on dbfs_files (marked, tombstoned);
