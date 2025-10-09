-- create drink_cart table
CREATE TABLE IF NOT EXISTS cart_drinks (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  image TEXT NOT NULL,
  type TEXT NOT NULL,
  price INTEGER NOT NULL,
  temp_level TEXT  NOT NULL,
  sugar_level TEXT  NOT NULL,
  ice_level TEXT NOT NULL,
  temperature TEXT  NOT NULL,
  can_be_hot INTEGER NOT NULL CHECK(can_be_hot IN (0,1)),
  can_be_cold INTEGER NOT NULL CHECK(can_be_cold IN (0,1))
  quantity INTEGER NOT NULL DEFAULT 1
);

-- create toppings table
CREATE TABLE IF NOT EXISTS toppings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  price INTEGER NOT NULL
);


-- Syrups table
CREATE TABLE IF NOT EXISTS syrups (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  price INTEGER NOT NULL
);

-- create cart_drinks_toppings join table
-- Many-to-many linking cart_drinks → toppings
CREATE TABLE IF NOT EXISTS cart_drink_toppings (
  cart_drink_id INTEGER NOT NULL,
  topping_id INTEGER NOT NULL,
  FOREIGN KEY (cart_drink_id) REFERENCES cart_drinks (id) ON DELETE CASCADE,
  FOREIGN KEY (topping_id) REFERENCES toppings (id) ON DELETE CASCADE
);


-- create cart_drinks_syrup join table
-- Many-to-many linking cart_drinks → syrups
CREATE TABLE IF NOT EXISTS cart_drink_syrups (
  cart_drink_id INTEGER NOT NULL,
  syrup_id INTEGER NOT NULL,
  FOREIGN KEY (cart_drink_id) REFERENCES cart_drinks (id) ON DELETE CASCADE,
  FOREIGN KEY (syrup_id) REFERENCES syrups (id) ON DELETE CASCADE
);