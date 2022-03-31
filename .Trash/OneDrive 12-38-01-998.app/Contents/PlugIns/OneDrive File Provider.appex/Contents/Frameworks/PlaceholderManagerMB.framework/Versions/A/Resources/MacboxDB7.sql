ALTER TABLE dbfs_files
ADD COLUMN observed_state INT DEFAULT 0;

CREATE TABLE dbfs_dbStateBlob (
  label TEXT PRIMARY KEY,
  data BLOB
) WITHOUT ROWID;
