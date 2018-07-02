-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 02, 2018 at 03:28 AM
-- Server version: 10.1.25-MariaDB
-- PHP Version: 5.6.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `restaurant`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(111) NOT NULL,
  `name` varchar(111) NOT NULL,
  `image_url` varchar(111) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `image_url`, `created_at`) VALUES
(1, 'food', 'food.jpg', '2018-06-16 18:34:04'),
(2, 'pizzas', 'pizzas.jpg', '2018-06-16 18:34:04'),
(3, 'Salads', 'salads.jpeg', '2018-06-16 18:34:04'),
(4, 'Appetizers', 'appetizer.jpg', '2018-06-16 18:38:11'),
(5, 'Entrees', 'entrees.jpg', '2018-06-16 18:38:11'),
(6, 'Beverages', 'beverages.jpg', '2018-06-16 18:38:11'),
(7, 'coffee', 'coffee.jpeg', '2018-06-17 15:58:51'),
(8, 'extras', 'extras.jpg', '2018-06-18 07:52:00');

-- --------------------------------------------------------

--
-- Table structure for table `food_extras`
--

CREATE TABLE `food_extras` (
  `id` int(111) NOT NULL,
  `category` int(111) NOT NULL,
  `name` varchar(111) NOT NULL,
  `image_url` varchar(111) NOT NULL,
  `price` int(111) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `food_extras`
--

INSERT INTO `food_extras` (`id`, `category`, `name`, `image_url`, `price`, `created_at`) VALUES
(1, 8, 'Stir-Fried Salt & Pepper Venison', 'a.jpg', 500, '2018-06-18 08:27:31'),
(2, 8, 'Smoked Carrot & Violet Mussels', 'b.jpg', 800, '2018-06-18 08:27:31'),
(3, 8, 'Grilled Mountain Vegetable Mix', 'c.jpg', 1200, '2018-06-18 08:27:31'),
(4, 8, 'Saffron and Mango Pastry', 'd.jpg', 3000, '2018-06-18 08:27:31'),
(5, 8, 'White Wine Molten Cake', 'e.jpg', 2500, '2018-06-18 08:27:31'),
(6, 8, 'Dark Chocolate Custard', 'f.jpg', 4000, '2018-06-18 08:27:31');

-- --------------------------------------------------------

--
-- Table structure for table `food_items`
--

CREATE TABLE `food_items` (
  `id` int(111) NOT NULL,
  `category` int(111) NOT NULL,
  `name` varchar(111) NOT NULL,
  `price` int(111) NOT NULL,
  `image_url` varchar(111) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `food_items`
--

INSERT INTO `food_items` (`id`, `category`, `name`, `price`, `image_url`, `created_at`) VALUES
(1, 1, 'Breaded Cranberry Chicken', 2500, 'a.jpg', '2018-06-17 17:14:00'),
(2, 2, 'Grilled Stew of Salmon', 1000, 'b.jpg', '2018-06-17 17:14:00'),
(3, 5, 'Pressure-Fried Creamy Bread', 3000, 'c.jpg', '2018-06-17 17:14:00'),
(4, 3, 'Ginger and Coffee Custard', 4500, 'd.jpg', '2018-06-17 17:14:00'),
(5, 7, 'White Wine Split', 6000, 'e.jpg', '2018-06-17 17:14:00'),
(6, 3, 'Grape Tarte Tatin', 3500, 'f.jpg', '2018-06-17 17:14:00'),
(7, 7, 'Stewed Pine Mammoth', 1500, 'g.jpg', '2018-06-17 17:14:00'),
(8, 6, 'Stuffed Saffron Flatbread', 1300, 'h.jpg', '2018-06-17 17:14:00'),
(9, 1, 'Simmered Cranberry Tuna', 1400, 'i.jpeg', '2018-06-17 17:14:00'),
(10, 6, 'Cranberry and Ginger Fudge', 1700, 'j.jpeg', '2018-06-17 17:16:03'),
(11, 3, 'Stuffed Wasabi Yak', 4000, 'k.jpeg', '2018-06-17 17:16:03');

-- --------------------------------------------------------

--
-- Table structure for table `purchases`
--

CREATE TABLE `purchases` (
  `id` int(111) NOT NULL,
  `user_id` int(111) NOT NULL,
  `item_id` int(111) NOT NULL,
  `quantity` int(111) NOT NULL,
  `price` int(111) NOT NULL,
  `total` int(111) NOT NULL,
  `order_id` varchar(111) NOT NULL,
  `status` varchar(111) NOT NULL,
  `payment_type` varchar(111) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `purchases`
--

INSERT INTO `purchases` (`id`, `user_id`, `item_id`, `quantity`, `price`, `total`, `order_id`, `status`, `payment_type`, `created_at`, `updated_at`) VALUES
(1, 1, 11, 1, 4000, 4000, '', 'pending', '', '2018-06-25 17:32:36', '2018-06-25 17:32:42.000000'),
(2, 1, 10, 1, 1700, 1700, '', 'pending', '', '2018-06-25 17:37:39', '0000-00-00 00:00:00.000000'),
(3, 1, 9, 1, 1400, 1400, '', 'pending', '', '2018-06-25 17:39:56', '0000-00-00 00:00:00.000000'),
(4, 1, 7, 1, 1500, 1500, '', 'pending', '', '2018-06-25 17:40:09', '0000-00-00 00:00:00.000000'),
(5, 1, 3, 1, 3000, 3000, '', 'pending', '', '2018-06-25 17:42:02', '0000-00-00 00:00:00.000000');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(111) NOT NULL,
  `user_key` varchar(111) NOT NULL,
  `name` varchar(111) NOT NULL,
  `email` varchar(111) NOT NULL,
  `api_key` varchar(111) NOT NULL,
  `user_type` varchar(111) NOT NULL,
  `status` varchar(111) NOT NULL,
  `created_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_on` timestamp(6) NOT NULL DEFAULT '0000-00-00 00:00:00.000000'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_key`, `name`, `email`, `api_key`, `user_type`, `status`, `created_on`, `updated_on`) VALUES
(1, 'tu2Z2ngel9X4UdHelEqTpgxir1K2', 'Trey Rosius', 'treyrosius@gmail.com', '93d065fcb5a7bc2089e5b8e1b9cbae5e', 'customer', 'active', '2018-06-22 16:04:00', '2018-06-26 10:36:34.000000'),
(2, '234kjhjdhadl;kasjd', 'Ndimofor', 'ateh@yahoo.com', 'c661ff447a7e21cb90de74b4dadf195b', 'customer', 'active', '2018-06-22 16:19:00', '2018-06-22 16:20:16.000000');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `food_extras`
--
ALTER TABLE `food_extras`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category` (`category`);

--
-- Indexes for table `food_items`
--
ALTER TABLE `food_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category` (`category`);

--
-- Indexes for table `purchases`
--
ALTER TABLE `purchases`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `food_extras`
--
ALTER TABLE `food_extras`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `food_items`
--
ALTER TABLE `food_items`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `purchases`
--
ALTER TABLE `purchases`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(111) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `food_extras`
--
ALTER TABLE `food_extras`
  ADD CONSTRAINT `food_extras_ibfk_1` FOREIGN KEY (`category`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `food_items`
--
ALTER TABLE `food_items`
  ADD CONSTRAINT `food_items_ibfk_1` FOREIGN KEY (`category`) REFERENCES `categories` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
