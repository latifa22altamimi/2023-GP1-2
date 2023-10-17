-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 17, 2023 at 02:07 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rehaab`
--

-- --------------------------------------------------------

--
-- Table structure for table `adminpram`
--

CREATE TABLE `adminpram` (
  `id` int(20) NOT NULL,
  `NumOfSingleV` int(7) NOT NULL,
  `NumOfDoubleV` int(7) NOT NULL,
  `NumOfVehicles` int(7) NOT NULL,
  `ReservationDur` int(3) NOT NULL,
  `numOfVehiclesInSlot` int(7) NOT NULL,
  `date` varchar(10) NOT NULL,
  `time` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adminpram`
--

INSERT INTO `adminpram` (`id`, `NumOfSingleV`, `NumOfDoubleV`, `NumOfVehicles`, `ReservationDur`, `numOfVehiclesInSlot`, `date`, `time`) VALUES
(1, 7, 13, 20, 90, 3, '2023-10-16', '19:30');

-- --------------------------------------------------------

--
-- Table structure for table `markers`
--

CREATE TABLE `markers` (
  `id` int(11) NOT NULL,
  `Latitude` double NOT NULL,
  `Longitude` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `markers`
--

INSERT INTO `markers` (`id`, `Latitude`, `Longitude`) VALUES
(1, 21.425391904127395, 39.824971878215585),
(2, 21.424083547667347, 39.82654901701323),
(3, 21.427279512254483, 39.82886644545058);

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `id` int(20) NOT NULL,
  `date` varchar(10) NOT NULL,
  `time` varchar(6) NOT NULL,
  `VehicleType` varchar(6) NOT NULL,
  `drivingType` varchar(20) NOT NULL,
  `driverGender` varchar(20) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `visitorId` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`id`, `date`, `time`, `VehicleType`, `drivingType`, `driverGender`, `Status`, `visitorId`) VALUES
(1, '2023-10-23', '18:00', 'Single', 'Self driving', NULL, 'Confirmed', 44),
(3, '2023-11-10', '16:00', 'Single', 'Self driving', NULL, 'Cancelled', 44),
(4, '2023-10-16', '19:30', 'Double', 'WithDriver', 'Female', 'Confirmed', 44),
(35, '2023-10-17', '21:00', 'Single', 'Self-driving', '', 'Confirmed', 44),
(36, '2023-10-17', '21:00', 'Single', 'Self-driving', '', 'Confirmed', 44),
(37, '2023-10-17', '21:00', 'Single', 'Self-driving', '', 'Confirmed', 44),
(38, '2023-10-17', '15:00', 'Single', 'Self-driving', '', 'Confirmed', 44),
(39, '2023-10-17', '15:00', 'Single', 'Self-driving', '', 'Confirmed', 44),
(40, '2023-10-17', '15:00', 'Single', 'Self-driving', '', 'Confirmed', 44);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `ID` int(11) NOT NULL,
  `FirstName` varchar(30) NOT NULL,
  `LastName` varchar(30) NOT NULL,
  `Email` varchar(200) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Type` varchar(30) NOT NULL DEFAULT 'Al-Haram visitor',
  `Status` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`ID`, `FirstName`, `LastName`, `Email`, `Password`, `Type`, `Status`) VALUES
(44, 'Fatimah', 'alnaser', 'alnaserfatimah344@gmail.com', '$2y$10$KIqLBapuEtypAVCMqhOs7eSwNKrnZ1lqjknxO5uCTIV.sNaa0BZNS', 'Al-Haram visitor', 1);

-- --------------------------------------------------------

--
-- Table structure for table `vehicle`
--

CREATE TABLE `vehicle` (
  `id` int(20) NOT NULL,
  `Number` int(3) NOT NULL,
  `time` varchar(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicle`
--

INSERT INTO `vehicle` (`id`, `Number`, `time`) VALUES
(1, 3, '00:00'),
(2, 3, '1:30'),
(3, 3, '3:00'),
(4, 3, '4:30'),
(5, 3, '6:00'),
(6, 3, '7:30'),
(7, 3, '9:00'),
(8, 3, '10:30'),
(9, 3, '12:00'),
(10, 3, '13:30'),
(11, 3, '15:00'),
(12, 3, '16:30'),
(13, 3, '18:00'),
(14, 3, '19:30'),
(15, 3, '21:00'),
(16, 3, '22:30');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adminpram`
--
ALTER TABLE `adminpram`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `markers`
--
ALTER TABLE `markers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`id`),
  ADD KEY `visitorId` (`visitorId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `vehicle`
--
ALTER TABLE `vehicle`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adminpram`
--
ALTER TABLE `adminpram`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `markers`
--
ALTER TABLE `markers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`visitorId`) REFERENCES `users` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

