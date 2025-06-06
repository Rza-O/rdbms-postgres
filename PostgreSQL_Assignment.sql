-- creating database
CREATE DATABASE conservation_db;
-- creating "rangers" table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    region TEXT NOT NULL
);
--creating species table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name TEXT NOT NULL,
    discovery_date DATE,
    conservation_status VARCHAR(50)
);
-- creating sighting table
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER REFERENCES species (species_id) NOT NULL,
    ranger_id INTEGER REFERENCES rangers (ranger_id) NOT NULL,
    location TEXT NOT NULL,
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
);

-- populating all the table created above
INSERT INTO
    rangers
VALUES (
        1,
        'Alice Green',
        'Northern Hills'
    ),
    (2, 'Bob White', 'River Delta'),
    (
        3,
        'Carol King',
        'Mountain Range'
    )

INSERT INTO
    species
VALUES (
        1,
        'Snow Leopard',
        'Panthera uncia',
        '1775-01-01',
        'Endangered'
    ),
    (
        2,
        'Bengal Tiger',
        'Panthera tigris tigris',
        '1758-01-01',
        'Endangered'
    ),
    (
        3,
        'Red Panda',
        'Ailurus fulgens',
        '1825-01-01',
        'Vulnerable'
    ),
    (
        4,
        'Asiatic Elephant',
        'Elephas maximus indicus',
        '1758-01-01',
        'Endangered'
    )

INSERT INTO
    sightings
VALUES (
        1,
        1,
        1,
        'Peak Ridge',
        '2024-05-10 07:45:00',
        'Camera trap image captured'
    ),
    (
        2,
        2,
        2,
        'Bankwood Area',
        '2024-05-12 16:20:00',
        'Juvenile seen'
    ),
    (
        3,
        3,
        3,
        'Bamboo Grove East',
        '2024-05-15 09:10:00',
        'Feeding observed'
    ),
    (
        4,
        1,
        2,
        'Snowfall Pass',
        '2024-05-18 18:30:00',
        NULL
    );

-- PROBLEM 1: Register a new ranger with provided data
INSERT INTO
    rangers (name, region)
VALUES ('Derek Fox', 'Coastal Plains');

-- PROBLEM 2: Count unique species ever sighted
SELECT count(DISTINCT species_id) as unique_species_count
FROM sightings;

-- PROBLEM 3: Find all sightings where the location includes "Pass"
SELECT * FROM sightings WHERE location ILIKE '%pass%';

-- PROBLEM 4: List each ranger's name and their total number of sightings
SELECT name, count(sighting_id) as total_sightings
FROM rangers
    LEFT JOIN sightings ON rangers.ranger_id = sightings.ranger_id
GROUP BY
    rangers.ranger_id,
    rangers.name;

-- PROBLEM 5: List species that have never been sighted.
SELECT common_name
FROM species
    LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE
    sightings.sighting_id IS NULL;

--PROBLEM 6: Show the most recent 2 sightings.
SELECT common_name, sighting_time, name
FROM
    sightings
    LEFT JOIN rangers ON sightings.ranger_id = rangers.ranger_id
    LEFT JOIN species ON sightings.species_id = species.species_id
ORDER BY sightings.sighting_time DESC
LIMIT 2;

-- PROBLEM 7: Update all species discovered before year 1800 to have status 'Historic'
UPDATE species
SET
    conservation_status = 'Historic'
WHERE
    discovery_date < '1800-01-01';

-- PROBLEM 8: Label each sighting's time of day as 'Morning', 'Afternoon', or 'Evening'
SELECT
    sighting_id,
    CASE
        WHEN EXTRACT(
            hour
            FROM sighting_time
        ) < 12 THEN 'Morning'
        WHEN 12 < EXTRACT(
            hour
            FROM sighting_time
        )
        AND EXTRACT(
            hour
            FROM sighting_time
        ) < 17 THEN 'Afternoon'
        WHEN EXTRACT(
            hour
            FROM sighting_time
        ) > 17 THEN 'Evening'
    END AS time_of_day
FROM sightings;

-- PROBLEM 9: Delete rangers who have never sighted any species
DELETE FROM rangers
WHERE
    ranger_id NOT IN (
        SELECT ranger_id
        FROM sightings
    );

SELECT * FROM rangers;

SELECT * FROM species;

SELECT * FROM sightings;