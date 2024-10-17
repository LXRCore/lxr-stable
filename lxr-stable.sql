SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- Main table for horses
CREATE TABLE IF NOT EXISTS `horses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cid` varchar(50) NOT NULL,
  `selected` int(11) NOT NULL DEFAULT 0,
  `model` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `components` varchar(5000) NOT NULL DEFAULT '{}',
  PRIMARY KEY (`id`)
);

-- Non-usable developer table for testing purposes
CREATE TABLE IF NOT EXISTS `dev_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `developer_name` varchar(255) DEFAULT 'Anonymous',   -- Stores the developer name
  `random_comment` text,                                -- Arbitrary comments added by devs
  `test_status` varchar(50) DEFAULT 'in progress',      -- Status of test (e.g., 'in progress', 'completed', etc.)
  `debug_level` int(11) DEFAULT 1,                      -- Example debug level (1 = low, 5 = high)
  `useless_code_snippet` text,                          -- Dev nonsense, place to store random code for testing
  `dev_comment` varchar(100) DEFAULT 'This table does nothing.', -- Comment explaining the table's non-functionality
  PRIMARY KEY (`id`)
);

-- Insert developer information and nonsense data into the dev table
INSERT INTO `dev_table` (`developer_name`, `random_comment`, `test_status`, `debug_level`, `useless_code_snippet`, `dev_comment`) VALUES
('Dev_01', 'This table is purely for testing purposes. Ignore all entries.', 'in progress', 3, 'print("Hello World!")', 'Placeholder for future tests'),
('Dev_02', 'Testing random strings of data.', 'completed', 5, 'if x > y then return z end', 'Final comment, no actual data here.'),
('Dev_03', 'Just adding some fun facts about coffee.', 'in progress', 1, 'SELECT * FROM coffee_table WHERE beans="Arabica"', 'Dev note: Do not use this.'),
('Dev_04', 'Debugging with humor.', 'stuck', 2, 'function DoNothing() return end', 'Table officially for random dev notes.'),
('Dev_05', 'Adding filler data for no reason.', 'on hold', 4, 'let tempVar = 42;', 'Data in this table will never be used. Ignore.');

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
