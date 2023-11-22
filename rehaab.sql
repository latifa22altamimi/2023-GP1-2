-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 22, 2023 at 11:37 AM
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
  `time` varchar(20) NOT NULL,
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
(102, '2023-11-17', '22:30 PM', 'Single', 'Self-driving', '', 'Active', 44),
(104, '2023-11-20', '22:30 PM', 'Single', 'Self-driving', '', 'Cancelled', 44),
(105, '2023-11-20', '22:30 PM', 'Single', 'Self-driving', '', 'Active', 44),
(106, '2023-11-20', '22:30 PM', 'Single', 'Self-driving', '', 'Active', 44),
(107, '2023-11-20', '22:30 PM', 'Single', 'Self-driving', '', 'Active', 52),
(108, '2023-11-20', '22:30 PM', 'Single', 'Self-driving', '', 'Confirmed', 52),
(109, '2023-11-20', '22:30 PM', 'Single', 'Self-driving', '', 'Confirmed', 44);

-- --------------------------------------------------------

--
-- Table structure for table `support`
--

CREATE TABLE `support` (
  `supportID` int(11) NOT NULL,
  `UserId` int(11) NOT NULL,
  `Latitude` double NOT NULL,
  `Longitude` double NOT NULL,
  `Message` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tawaf`
--

CREATE TABLE `tawaf` (
  `TDurationId` int(11) NOT NULL,
  `UserId` int(11) NOT NULL,
  `TDuration` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `timeslots`
--

CREATE TABLE `timeslots` (
  `id` int(20) NOT NULL,
  `time` varchar(20) NOT NULL,
  `numberOfSingleV` int(5) NOT NULL,
  `numberOfDoubleV` int(5) NOT NULL,
  `slotStatus` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `timeslots`
--

INSERT INTO `timeslots` (`id`, `time`, `numberOfSingleV`, `numberOfDoubleV`, `slotStatus`) VALUES
(1, '00:00 AM', 3, 3, 'Both'),
(2, '01:30 AM', 3, 3, 'Both'),
(3, '03:00 AM', 3, 3, 'Both'),
(4, '04:30 AM', 3, 3, 'Both'),
(5, '06:00 AM', 3, 3, 'Both'),
(6, '07:30 AM', 3, 3, 'Both'),
(7, '09:00 AM', 3, 3, 'Both'),
(8, '10:30 AM', 3, 3, 'Both'),
(9, '12:00 PM', 3, 3, 'Both'),
(10, '13:30 PM', 3, 3, 'Both'),
(11, '15:00 PM', 3, 3, 'Both'),
(12, '16:30 PM', 3, 3, 'Both'),
(13, '18:00 PM', 3, 3, 'Both'),
(14, '19:30 PM', 3, 3, 'Both'),
(15, '21:00 PM', 3, 3, 'Both'),
(16, '22:30 PM', 3, 3, 'Both');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `userID` int(11) NOT NULL,
  `FullName` varchar(30) NOT NULL,
  `Email` varchar(200) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Type` varchar(30) NOT NULL DEFAULT 'Al-Haram visitor',
  `VerificationStatus` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`userID`, `FullName`, `Email`, `Password`, `Type`, `VerificationStatus`) VALUES
(44, 'Fatimah', 'alnaserfatimah344@gmail.com', '$2y$10$KIqLBapuEtypAVCMqhOs7eSwNKrnZ1lqjknxO5uCTIV.sNaa0BZNS', 'Al-Haram visitor', 1),
(51, 'fa', 'alnaserfatimah4@gmail.com', '$2y$10$LIBZfiFkJ.HVGyLnhAQFeOhWTC/Hx/uOBf0NKlvCMJzI5w/Qj/iYi', 'Al-Haram visitor', 1),
(52, 'Manal Alyami', 'manalalyami7@gmail.com', '$2y$10$y.S07Y5Cm25vK3pCWZn1O.Uk8BZSw5OOaptTVFliaQIa0NLfrJfn2', 'Al-Haram visitor', 1);

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
-- Indexes for table `support`
--
ALTER TABLE `support`
  ADD PRIMARY KEY (`supportID`),
  ADD KEY `support_ibfk_1` (`UserId`);

--
-- Indexes for table `tawaf`
--
ALTER TABLE `tawaf`
  ADD PRIMARY KEY (`TDurationId`),
  ADD KEY `UserId` (`UserId`);

--
-- Indexes for table `timeslots`
--
ALTER TABLE `timeslots`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`);

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
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=110;

--
-- AUTO_INCREMENT for table `support`
--
ALTER TABLE `support`
  MODIFY `supportID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tawaf`
--
ALTER TABLE `tawaf`
  MODIFY `TDurationId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `timeslots`
--
ALTER TABLE `timeslots`
  MODIFY `id` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`visitorId`) REFERENCES `users` (`userID`);

--
-- Constraints for table `support`
--
ALTER TABLE `support`
  ADD CONSTRAINT `support_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `users` (`userID`);

--
-- Constraints for table `tawaf`
--
ALTER TABLE `tawaf`
  ADD CONSTRAINT `tawaf_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `users` (`userID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
