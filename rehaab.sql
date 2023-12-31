-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 03, 2023 at 12:14 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

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
-- Table structure for table `markers`
--

CREATE TABLE `markers` (
  `MarkerId` int(11) NOT NULL,
  `Latitude` double NOT NULL,
  `Longitude` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `markers`
--

INSERT INTO `markers` (`MarkerId`, `Latitude`, `Longitude`) VALUES
(1, 21.425391904127395, 39.824971878215585),
(2, 21.424083547667347, 39.82654901701323),
(3, 21.427279512254483, 39.82886644545058);

-- --------------------------------------------------------

--
-- Table structure for table `parameters`
--

CREATE TABLE `parameters` (
  `ParametersId` int(15) NOT NULL,
  `ReservationDur` varchar(30) NOT NULL,
  `NumOfWalkInVehicles` int(15) NOT NULL,
  `NumOfBackUpVehicles` int(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `reservation`
--

CREATE TABLE `reservation` (
  `reservationId` int(20) NOT NULL,
  `date` varchar(10) NOT NULL,
  `VehicleType` varchar(6) NOT NULL,
  `drivingType` varchar(20) NOT NULL,
  `driverGender` varchar(20) DEFAULT NULL,
  `Status` varchar(20) NOT NULL,
  `visitorId` int(20) NOT NULL,
  `slotId` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `support`
--

CREATE TABLE `support` (
  `supportID` int(11) NOT NULL,
  `ReservationId` int(11) NOT NULL,
  `Latitude` varchar(200) NOT NULL,
  `Longitude` varchar(200) NOT NULL,
  `Message` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tawaf`
--

CREATE TABLE `tawaf` (
  `TDurationId` int(11) NOT NULL,
  `UserId` int(11) NOT NULL,
  `TDuration` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `timeslots`
--

CREATE TABLE `timeslots` (
  `slotId` int(20) NOT NULL,
  `time` varchar(20) NOT NULL,
  `numberOfSingleV` int(5) NOT NULL,
  `numberOfDoubleV` int(5) NOT NULL,
  `slotStatus` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `timeslots`
--

INSERT INTO `timeslots` (`slotId`, `time`, `numberOfSingleV`, `numberOfDoubleV`, `slotStatus`) VALUES
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
(44, 'Fatimah', 'alnaserfatimah344@gmail.com', '$2y$10$7xFLClUeua9sUgzuXqFy.OntRYLpxloW5yc9bX7/e9smMFIMmKD9y', 'Al-Haram visitor', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `markers`
--
ALTER TABLE `markers`
  ADD PRIMARY KEY (`MarkerId`);

--
-- Indexes for table `parameters`
--
ALTER TABLE `parameters`
  ADD PRIMARY KEY (`ParametersId`);

--
-- Indexes for table `reservation`
--
ALTER TABLE `reservation`
  ADD PRIMARY KEY (`reservationId`),
  ADD KEY `visitorId` (`visitorId`),
  ADD KEY `slotId` (`slotId`);

--
-- Indexes for table `support`
--
ALTER TABLE `support`
  ADD PRIMARY KEY (`supportID`),
  ADD KEY `support_ibfk_1` (`ReservationId`);

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
  ADD PRIMARY KEY (`slotId`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`userID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `markers`
--
ALTER TABLE `markers`
  MODIFY `MarkerId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `parameters`
--
ALTER TABLE `parameters`
  MODIFY `ParametersId` int(15) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservation`
--
ALTER TABLE `reservation`
  MODIFY `reservationId` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=205;

--
-- AUTO_INCREMENT for table `support`
--
ALTER TABLE `support`
  MODIFY `supportID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `tawaf`
--
ALTER TABLE `tawaf`
  MODIFY `TDurationId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=80;

--
-- AUTO_INCREMENT for table `timeslots`
--
ALTER TABLE `timeslots`
  MODIFY `slotId` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `userID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `reservation`
--
ALTER TABLE `reservation`
  ADD CONSTRAINT `reservation_ibfk_2` FOREIGN KEY (`visitorId`) REFERENCES `users` (`userID`),
  ADD CONSTRAINT `reservation_ibfk_3` FOREIGN KEY (`slotId`) REFERENCES `timeslots` (`slotId`);

--
-- Constraints for table `support`
--
ALTER TABLE `support`
  ADD CONSTRAINT `support_ibfk_1` FOREIGN KEY (`ReservationId`) REFERENCES `reservation` (`reservationId`);

--
-- Constraints for table `tawaf`
--
ALTER TABLE `tawaf`
  ADD CONSTRAINT `tawaf_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `users` (`userID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
