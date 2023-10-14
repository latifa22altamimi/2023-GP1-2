-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 14, 2023 at 01:56 AM
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
  `numOfVehiclesInSlot` int(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adminpram`
--

INSERT INTO `adminpram` (`id`, `NumOfSingleV`, `NumOfDoubleV`, `NumOfVehicles`, `ReservationDur`, `numOfVehiclesInSlot`) VALUES
(1, 7, 3, 10, 90, 3);

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
  `vehicleId` int(20) NOT NULL,
  `drivingType` varchar(20) NOT NULL,
  `driverGender` varchar(20) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `visitorId` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reservation`
--

INSERT INTO `reservation` (`id`, `date`, `time`, `vehicleId`, `drivingType`, `driverGender`, `Status`, `visitorId`) VALUES
(1, '2023-10-23', '18:00', 1, 'Self driving', NULL, 'Confirmed', 44),
(3, '2023-11-10', '16:00', 33, 'Self driving', NULL, 'Cancelled', 44);

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
  `VehicleType` varchar(7) NOT NULL,
  `Vehiclestatus` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vehicle`
--

INSERT INTO `vehicle` (`id`, `VehicleType`, `Vehiclestatus`) VALUES
(1, 'Single', 'booked'),
(30, 'Single', 'Avaliable'),
(31, 'Single', 'Avaliable'),
(32, 'Single', 'Avaliable'),
(33, 'Single', 'Avaliable'),
(34, 'Single', 'Avaliable'),
(35, 'Single', 'Avaliable'),
(36, 'Double', 'Avaliable'),
(37, 'Double', 'Avaliable'),
(38, 'Double', 'Avaliable');

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
  ADD KEY `vehicleId` (`vehicleId`),
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
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `vehicle`
--
ALTER TABLE `vehicle`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`vehicleId`) REFERENCES `vehicle` (`id`),
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`visitorId`) REFERENCES `users` (`ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
