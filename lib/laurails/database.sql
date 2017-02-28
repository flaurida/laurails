CREATE TABLE hedgehogs (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  color VARCHAR(255) NOT NULL,
  owner_id INTEGER,

  FOREIGN KEY(owner_id) REFERENCES person(id)
);

CREATE TABLE people (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER,

  FOREIGN KEY(house_id) REFERENCES person(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (id, address)
VALUES
  (1, "160 E 23rd Street"), (2, "159 W 25th Street");

INSERT INTO
  people (id, fname, lname, house_id)
VALUES
  (1, "Laura", "Cressman", 1),
  (2, "Charmander", "Cressman", 1),
  (3, "Kristen", "Redacted", 2),
  (4, "Hedgehogless", "Person", NULL);

INSERT INTO
  hedgehogs (id, name, color, owner_id)
VALUES
  (1, "Quilvia Plath", "dark grey", 1),
  (2, "Clementine", "dark grey", 1),
  (3, "Charizard", "cinnamon", 2),
  (4, "Spike", "pinto", 3),
  (5, "Stray Hedgehog", "albino", NULL);
