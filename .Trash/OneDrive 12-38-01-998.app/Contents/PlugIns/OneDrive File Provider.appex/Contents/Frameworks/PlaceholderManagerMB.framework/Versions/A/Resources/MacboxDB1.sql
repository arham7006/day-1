CREATE TABLE dbfs_files (
    itemid INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    fsid INTEGER NOT NULL,
    tagid TEXT COLLATE NOCASE,
    content_hash TEXT DEFAULT "" NOT NULL COLLATE NOCASE,
    filetype INTEGER DEFAULT 0 NOT NULL,
    anchor INTEGER DEFAULT 0 NOT NULL UNIQUE,
    content_version INTEGER DEFAULT 0 NOT NULL,
    parentid INTEGER NOT NULL,
    name TEXT NOT NULL COLLATE NOCASE,
    size INTEGER DEFAULT 0 NOT NULL,
    ctime INTEGER DEFAULT 0 NOT NULL,
    mtime INTEGER DEFAULT 0 NOT NULL,
    tombstoned INTEGER DEFAULT 0 NOT NULL,
    uti TEXT NOT NULL COLLATE NOCASE,
    state_flags INTEGER DEFAULT 0 NOT NULL,
    error_code INTEGER DEFAULT 0 NOT NULL,
    atime INTEGER DEFAULT -1 NOT NULL,
    tagdata BLOB,
    favorite_rank INTEGER DEFAULT -1 NOT NULL,
    file_system_flags INTEGER DEFAULT -1 NOT NULL,
    xattrs BLOB,
    capabilities INTEGER DEFAULT -1 NOT NULL,
    secondary_state INTEGER DEFAULT -1 NOT NULL
);

-- Create the general state table
CREATE TABLE dbfs_dbstate (
    name TEXT PRIMARY KEY UNIQUE,
    value INTEGER
) WITHOUT ROWID;

