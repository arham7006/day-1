ALTER TABLE dbfs_files
ADD COLUMN symlink_target TEXT DEFAULT NULL;

ALTER TABLE dbfs_files
ADD COLUMN uti_override TEXT DEFAULT NULL;
