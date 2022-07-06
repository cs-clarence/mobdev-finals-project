import 'package:pc_parts_list/db/sqlite.dart';

int dbVersion = 4;

const MigrationScripts migrationScripts = [
  {
    "up": [
      //language=sqlite
      """
      CREATE TABLE IF NOT EXISTS accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      );
      """,
      //language=sqlite
      """
      CREATE TABLE IF NOT EXISTS profiles (
        accountId INTEGER PRIMARY KEY REFERENCES accounts(id) ON DELETE CASCADE ON UPDATE CASCADE,
        firstName TEXT NOT NULL,
        lastName TEXT NOT NULL,
        middleName TEXT,
        nameSuffix TEXT
      );
      """
    ],
    "down": [
      //language=sqlite
      """
      DROP TABLE IF EXISTS accounts;
      """,
      //language=sqlite
      """
      DROP TABLE IF EXISTS profiles;
      """
    ],
  },
  {
    "up": [
      //language=sqlite
      """
      ALTER TABLE accounts ADD COLUMN accessLevel INT DEFAULT 0 NOT NULL;
      """
    ],
    "seed": [
      //language=sqlite
      """
      INSERT 
        INTO 
          accounts(userName, email, password, accessLevel) 
        VALUES 
          ('admin_user', 'admin@gmail.com', 'admin_password', 10);
      """,
      //language=sqlite
      """
      INSERT 
        INTO 
          profiles(accountId, firstName, lastName) 
        VALUES 
          ((SELECT DISTINCT id FROM accounts WHERE userName = 'admin_user'), 'Clarence', 'Manuel');
      """,
    ],
    "down": [
      //language=sqlite
      """
      CREATE TEMPORARY TABLE accounts_backup(id, userName, email, password);
      """,
      //language=sqlite
      """
      INSERT INTO accounts_backup SELECT id, userName, email, password FROM accounts;
      """,
      //language=sqlite
      """
      DROP TABLE accounts;
      """,
      //language=sqlite
      """
      CREATE TABLE IF NOT EXISTS accounts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userName TEXT NOT NULL UNIQUE,
        email TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL
      );
      """,
      //language=sqlite
      """
      INSERT INTO accounts SELECT id, userName, email, password FROM accounts_backup;
      """
    ],
  },
  {
    "up": [
      //language=sqlite
      """
      ALTER TABLE accounts RENAME TO temp_accounts;
      """,
      //language=sqlite
      """
      ALTER TABLE temp_accounts RENAME TO Accounts;
      """,
      //language=sqlite
      """
      ALTER TABLE profiles RENAME TO temp_profiles;
      """,
      //language=sqlite
      """
      ALTER TABLE temp_profiles RENAME TO Profiles;
      """
    ],
    "down": [
      //language=sqlite
      """
      ALTER TABLE Accounts RENAME TO temp_accounts;
      """,
      //language=sqlite
      """
      ALTER TABLE temp_accounts RENAME TO accounts;
      """,
      //language=sqlite
      """
      ALTER TABLE Profiles RENAME TO temp_profiles;
      """,
      //language=sqlite
      """
      ALTER TABLE temp_profiles RENAME TO profiles;
      """
    ],
  },
  {
    "up": [
      //language=sqlite
      """
      CREATE TABLE PcParts (
        upc TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        brand TEXT NOT NULL,
        type TEXT NOT NULL,
        price REAL NOT NULL
      );
      """,
      //language=sqlite
      """
      CREATE TABLE PartsLists (
        id TEXT PRIMARY KEY,
        userName TEXT NOT NULL REFERENCES Accounts(userName) ON DELETE CASCADE ON UPDATE CASCADE,
        name TEXT NOT NULL
      );
      """,
      //language=sqlite
      """
      CREATE TABLE PcPartsToPartsLists (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        partsListId TEXT REFERENCES PartsLists(id) ON DELETE CASCADE ON UPDATE CASCADE,
        pcPartUpc TEXT REFERENCES PcParts(upc) ON DELETE CASCADE ON UPDATE CASCADE
      );
      """
    ],
    "seed": [
      //language=sqlite
      """
      INSERT 
        INTO 
          PcParts(upc, name, brand, type, price) 
        VALUES 
          -- CPU
          ('9-346556-456555', 'Ryzen 5 3600', 'AMD', 'cpu', 10000),
          ('3-346556-456555', 'Ryzen 5 2600', 'AMD', 'cpu', 6000),
          ('4-444555-123412', 'Ryzen 5 5600X', 'AMD', 'cpu', 20000),
          ('5-123123-123455', 'Ryzen 7 5800X', 'AMD', 'cpu', 25000),
          ('6-123445-123444', 'Ryzen 7 5700', 'AMD', 'cpu', 23000),
          ('7-413145-512345', 'Ryzen 7 3700', 'AMD', 'cpu', 15000),
          ('8-123515-143515', 'Ryzen 3 3100', 'AMD', 'cpu', 5100),
          ('1-123515-143515', 'Ryzen 3 2100', 'AMD', 'cpu', 3000),
          ('2-123515-123455', 'Ryzen 3 3300G', 'AMD', 'cpu', 7000),
          -- MOTHERBOARD
          ('2-123415-123345', 'B450M Mortar Max', 'MSI', 'motherboard', 5000),
          ('3-123415-123345', 'B550M Mortar Max', 'MSI', 'motherboard', 8000),
          ('4-123415-123345', 'X570 MAG Mortar', 'MSI', 'motherboard', 10000),
          ('5-123415-123345', 'A320EX Gaming', 'Asus', 'motherboard', 3200),
          -- RAM
          ('1-143415-143445', 'VENGEANCE DDR4 3200Mhz RGB 32GB', 'Corsair', 'ram', 10500),
          ('2-123415-123445', 'VENGEANCE DDR4 3200Mhz RGB 16GB', 'Corsair', 'ram', 6500),
          ('3-123115-123945', 'VENGEANCE DDR4 3200Mhz RGB 8GB', 'Corsair', 'ram', 3500),
          ('4-123415-123445', 'HyperX DDR4 3200Mhz 32GB', 'Kingston', 'ram', 9500),
          ('5-123415-123845', 'HyperX DDR4 3200Mhz 16GB', 'Kingston', 'ram', 5500),
          ('6-123515-133445', 'HyperX DDR4 3200Mhz 8GB', 'Kingston', 'ram', 3000),
          -- VIDEO CARD
          ('1-123455-123455', 'RTX 3080', 'NVIDIA', 'video-card', 55000),
          ('2-193455-123455', 'RTX 3070', 'NVIDIA', 'video-card', 43000),
          ('3-173455-123455', 'RTX 3060', 'NVIDIA', 'video-card', 26000),
          ('4-169455-123455', 'RTX 2060', 'NVIDIA', 'video-card', 18000),
          ('5-123455-123455', 'GTX 1650', 'NVIDIA', 'video-card', 13000),
          ('6-127455-123455', 'GTX 1050 Ti', 'NVIDIA', 'video-card', 8000),
          ('7-933455-123455', 'GTX 1050', 'NVIDIA', 'video-card', 5000),
          ('8-123455-223459', 'RADEON RX570 4GB', 'AMD', 'video-card', 7000),
          ('1-133453-123475', 'RADEON RX570 8GB', 'AMD', 'video-card', 9000),
          ('1-127251-123375', 'RADEON RX580', 'AMD', 'video-card', 9000),
          ('2-143415-123244', 'RADEON RX580', 'AMD', 'video-card', 1100),
          -- POWER SUPPLY
          ('1-453415-142455', 'RM850', 'Corsair', 'power-supply', 10000),
          ('2-163415-112455', 'HX750', 'Corsair', 'power-supply', 7500),
          ('3-193415-172455', 'CV750', 'Corsair', 'power-supply', 3600),
          ('4-173415-192355', 'CV650', 'Corsair', 'power-supply', 3300),
          ('5-133415-112455', 'CV550', 'Corsair', 'power-supply', 3300),
          -- PC CHASSIS
          ('1-724145-143544', 'iCUE 4000D ATX Full Tower', 'Corsair', 'pc-chassis', 10000),
          ('2-624145-144514', '4000D ATX Full Tower', 'Corsair', 'pc-chassis', 4000),
          ('3-524145-149584', '5000D ATX Full Tower', 'Corsair', 'pc-chassis', 8000),
          ('4-424145-141513', 'Crystal Series 680X ATX Full Tower', 'Corsair', 'pc-chassis', 2500);
      """,
    ],
    "down": [
      //language=sqlite
      """
      DROP TABLE PcParts;
      """,
      //language=sqlite
      """
      DROP TABLE PartsLists;
      """,
      //language=sqlite
      """
      DROP TABLE PcPartsToPartsLists;
      """
    ],
  },
];
