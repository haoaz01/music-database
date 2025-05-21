-- Create the ARTIST table
CREATE TABLE ARTIST (
    artistName VARCHAR(100) PRIMARY KEY,
    nationality VARCHAR(50)
);

-- Create the LABEL table
CREATE TABLE LABEL (
    labelName VARCHAR(100) PRIMARY KEY,
    revenue NUMERIC(10,2)
);

-- Create the ALBUM table
CREATE TABLE ALBUM (
    albumTitle VARCHAR(100) PRIMARY KEY,
    releaseYear INT,
    producedBy VARCHAR(100),
    playedBy VARCHAR(100),
    FOREIGN KEY (producedBy) REFERENCES LABEL(labelName) ON DELETE CASCADE,
    FOREIGN KEY (playedBy) REFERENCES ARTIST(artistName) ON DELETE CASCADE
);

-- Create the SONG table
CREATE TABLE SONG (
    songTitle VARCHAR(100) PRIMARY KEY,
    length NUMERIC(5,2),
    writtenBy VARCHAR(100),
    writtenYear INT,
    FOREIGN KEY (writtenBy) REFERENCES ARTIST(artistName) ON DELETE CASCADE
);

-- Create the SONG_INALBUM table
CREATE TABLE SONG_INALBUM (
    albumSong VARCHAR(100),
    album VARCHAR(100),
    trackNumber INT,
    PRIMARY KEY (albumSong, album),
    FOREIGN KEY (albumSong) REFERENCES SONG(songTitle) ON DELETE CASCADE,
    FOREIGN KEY (album) REFERENCES ALBUM(albumTitle) ON DELETE CASCADE
);
-- Insert into ARTIST
INSERT INTO ARTIST VALUES ('John Doe', 'USA');
INSERT INTO ARTIST VALUES ('Jane Smith', 'UK');

-- Insert into LABEL
INSERT INTO LABEL VALUES ('Universal Music', 5000000);
INSERT INTO LABEL VALUES ('Sony Music', 3000000);

-- Insert into ALBUM
INSERT INTO ALBUM VALUES ('Rock Legends', 2020, 'Universal Music', 'John Doe');
INSERT INTO ALBUM VALUES ('Pop Hits', 2021, 'Sony Music', 'Jane Smith');

-- Insert into SONG
INSERT INTO SONG VALUES ('Rock Anthem', 3.45, 'John Doe', 2019);
INSERT INTO SONG VALUES ('Pop Magic', 4.12, 'Jane Smith', 2020);

-- Insert into SONG_INALBUM
INSERT INTO SONG_INALBUM VALUES ('Rock Anthem', 'Rock Legends', 1);
INSERT INTO SONG_INALBUM VALUES ('Pop Magic', 'Pop Hits', 1);
CREATE TABLE REVIEWS (
    magazine VARCHAR(100),
    releaseYear INT,
    issue INT,
    critic VARCHAR(100),
    albumTitle VARCHAR(100),
    rating VARCHAR(10) CHECK (rating IN ('positive', 'neutral', 'negative')),
    reviewText TEXT,
    PRIMARY KEY (magazine, albumTitle),
    FOREIGN KEY (albumTitle) REFERENCES ALBUM(albumTitle) ON DELETE CASCADE
);
SELECT 
    A.albumTitle,
    SUM(S.length) AS totalLength
FROM 
    SONG S
    JOIN SONG_INALBUM SI ON S.songTitle = SI.albumSong
    JOIN ALBUM A ON SI.album = A.albumTitle
GROUP BY 
    A.albumTitle;
SELECT 
    A.albumTitle,
    SUM(S.length) AS totalLength
FROM 
    SONG S
    JOIN SONG_INALBUM SI ON S.songTitle = SI.albumSong
    JOIN ALBUM A ON SI.album = A.albumTitle
GROUP BY 
    A.albumTitle;
INSERT INTO SONG (songTitle, length, writtenBy, writtenYear)
VALUES ('New Song', 3.33, 'John Doe', 2022);
SELECT artistName
FROM ARTIST
WHERE artistName NOT IN (
    SELECT a.artistName
    FROM ARTIST a, ALBUM m, SONG_INALBUM sa, SONG S
    WHERE a.artistName = m.playedBy 
    AND m.albumTitle = sa.album 
    AND sa.albumSong = s.songTitle 
    AND s.writtenBy != a.artistName
);
SELECT artistName
FROM ARTIST a
WHERE NOT EXISTS (
    SELECT *
    FROM LABEL l
    WHERE NOT EXISTS (
        SELECT *
        FROM ALBUM m
        WHERE m.producedBy = l.labelName 
        AND m.playedBy = a.artistName
    )
);
SELECT writtenYear
FROM SONG
GROUP BY writtenYear
HAVING SUM(length) = (
    SELECT MAX(ttl)
    FROM (
        SELECT SUM(length) AS ttl
        FROM SONG
        GROUP BY writtenYear
    ) sLen
);
