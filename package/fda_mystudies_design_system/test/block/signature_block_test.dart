import 'package:fda_mystudies_design_system/block/signature_block.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../test_util.dart';

void main() {
  const signature = [
    Offset(28.0, 115.7),
    Offset(29.0, 115.0),
    Offset(30.3, 113.7),
    Offset(31.7, 112.0),
    Offset(32.3, 111.0),
    Offset(33.7, 110.0),
    Offset(34.7, 109.3),
    Offset(35.0, 108.3),
    Offset(36.0, 107.7),
    Offset(37.0, 106.7),
    Offset(37.7, 105.7),
    Offset(38.0, 105.0),
    Offset(38.7, 104.7),
    Offset(39.0, 104.3),
    Offset(39.3, 103.7),
    Offset(40.0, 103.0),
    Offset(40.0, 102.7),
    Offset(41.7, 101.3),
    Offset(43.0, 100.0),
    Offset(44.0, 98.7),
    Offset(44.7, 98.0),
    Offset(45.0, 97.7),
    Offset(46.0, 96.7),
    Offset(46.3, 96.0),
    Offset(47.0, 95.7),
    Offset(47.0, 95.0),
    Offset(47.7, 94.7),
    Offset(48.3, 94.0),
    Offset(49.0, 93.3),
    Offset(49.0, 92.7),
    Offset(49.7, 92.0),
    Offset(50.7, 90.7),
    Offset(51.3, 90.3),
    Offset(51.3, 89.7),
    Offset(51.7, 89.3),
    Offset(52.3, 89.0),
    Offset(53.0, 88.0),
    Offset(54.0, 86.7),
    Offset(54.7, 85.7),
    Offset(55.3, 85.3),
    Offset(56.0, 84.7),
    Offset(56.3, 84.0),
    Offset(57.3, 82.3),
    Offset(58.0, 82.0),
    Offset(58.7, 81.0),
    Offset(59.7, 79.7),
    Offset(60.3, 79.0),
    Offset(60.7, 78.7),
    Offset(61.0, 78.3),
    Offset(61.3, 77.7),
    Offset(61.7, 77.3),
    Offset(62.3, 76.7),
    Offset(63.0, 75.7),
    Offset(63.7, 75.0),
    Offset(64.0, 74.7),
    Offset(65.0, 73.7),
    Offset(65.7, 72.7),
    Offset(66.3, 72.3),
    Offset(66.7, 71.3),
    Offset(67.3, 71.0),
    Offset(68.0, 70.3),
    Offset(68.3, 70.0),
    Offset(69.0, 69.3),
    Offset(69.3, 68.7),
    Offset(70.3, 67.7),
    Offset(71.0, 67.0),
    Offset(72.0, 65.7),
    Offset(72.3, 65.3),
    Offset(72.7, 65.3),
    Offset(73.0, 64.7),
    Offset(73.3, 64.3),
    Offset(73.3, 64.0),
    Offset(73.7, 63.3),
    Offset(74.0, 63.3),
    Offset(75.3, 61.7),
    Offset(76.0, 61.0),
    Offset(77.0, 60.0),
    Offset(77.3, 59.7),
    Offset(77.7, 59.0),
    Offset(77.7, 58.7),
    Offset(78.0, 58.3),
    Offset(78.3, 58.0),
    Offset(78.7, 58.0),
    Offset(79.0, 57.7),
    Offset(79.3, 57.0),
    Offset(79.3, 56.7),
    Offset(80.0, 56.3),
    Offset(80.0, 56.0),
    Offset(80.3, 56.0),
    Offset(80.3, 55.7),
    Offset(80.3, 56.0),
    Offset(80.3, 56.3),
    Offset(80.3, 56.7),
    Offset(80.3, 57.0),
    Offset(80.0, 57.3),
    Offset(80.0, 58.0),
    Offset(80.0, 58.3),
    Offset(79.7, 58.7),
    Offset(79.3, 58.7),
    Offset(79.3, 59.3),
    Offset(79.3, 59.7),
    Offset(79.3, 60.0),
    Offset(79.0, 60.7),
    Offset(79.0, 61.0),
    Offset(78.7, 62.0),
    Offset(78.0, 63.0),
    Offset(77.7, 63.7),
    Offset(77.7, 64.3),
    Offset(77.7, 64.7),
    Offset(77.7, 65.3),
    Offset(77.3, 65.3),
    Offset(77.0, 66.7),
    Offset(76.7, 67.3),
    Offset(76.3, 68.0),
    Offset(76.0, 68.3),
    Offset(75.7, 69.0),
    Offset(75.3, 70.0),
    Offset(75.3, 70.3),
    Offset(75.0, 71.3),
    Offset(74.7, 72.3),
    Offset(74.0, 73.7),
    Offset(73.3, 75.0),
    Offset(73.0, 75.7),
    Offset(72.7, 76.0),
    Offset(72.3, 77.0),
    Offset(72.3, 77.3),
    Offset(72.0, 78.0),
    Offset(71.7, 79.0),
    Offset(71.0, 80.3),
    Offset(70.7, 80.7),
    Offset(70.0, 82.0),
    Offset(69.7, 82.7),
    Offset(69.3, 83.7),
    Offset(69.3, 84.0),
    Offset(69.0, 85.0),
    Offset(69.0, 85.7),
    Offset(68.7, 86.0),
    Offset(68.3, 87.0),
    Offset(68.0, 87.7),
    Offset(67.7, 88.3),
    Offset(67.3, 89.3),
    Offset(67.0, 90.0),
    Offset(66.7, 91.3),
    Offset(66.7, 91.7),
    Offset(66.3, 92.3),
    Offset(66.3, 93.0),
    Offset(66.0, 93.3),
    Offset(66.0, 94.0),
    Offset(65.7, 94.3),
    Offset(65.7, 95.0),
    Offset(65.3, 95.7),
    Offset(65.0, 96.7),
    Offset(65.0, 97.3),
    Offset(64.7, 98.0),
    Offset(64.3, 99.3),
    Offset(64.3, 100.3),
    Offset(64.3, 100.7),
    Offset(64.0, 101.3),
    Offset(64.0, 102.0),
    Offset(63.7, 103.0),
    Offset(63.3, 104.0),
    Offset(63.0, 105.0),
    Offset(63.0, 106.0),
    Offset(62.7, 106.7),
    Offset(62.7, 107.0),
    Offset(62.7, 107.3),
    Offset(62.7, 107.7),
    Offset(62.7, 108.0),
    Offset(62.7, 108.3),
    Offset(62.7, 109.0),
    Offset(62.7, 109.3),
    Offset(63.0, 110.0),
    Offset(63.3, 110.3),
    Offset(63.7, 110.7),
    Offset(64.0, 110.7),
    Offset(64.0, 111.0),
    Offset(64.3, 111.0),
    Offset(64.7, 111.0),
    Offset(65.0, 111.0),
    Offset(65.3, 111.0),
    Offset(65.7, 111.0),
    Offset(66.0, 111.0),
    Offset(66.0, 110.7),
    Offset(66.7, 110.0),
    Offset(67.3, 109.0),
    Offset(68.0, 108.0),
    Offset(68.3, 107.0),
    Offset(69.0, 106.0),
    Offset(69.7, 105.0),
    Offset(70.3, 104.0),
    Offset(71.0, 103.0),
    Offset(71.0, 102.7),
    Offset(71.3, 102.0),
    Offset(72.0, 101.0),
    Offset(72.7, 99.7),
    Offset(73.3, 98.7),
    Offset(73.7, 98.0),
    Offset(74.0, 97.0),
    Offset(74.7, 96.7),
    Offset(75.3, 95.3),
    Offset(76.3, 94.0),
    Offset(77.0, 93.0),
    Offset(77.3, 92.0),
    Offset(77.7, 91.7),
    Offset(79.3, 89.3),
    Offset(79.7, 89.0),
    Offset(80.3, 88.0),
    Offset(80.3, 87.7),
    Offset(80.7, 87.0),
    Offset(81.3, 86.3),
    Offset(81.7, 86.0),
    Offset(82.3, 85.0),
    Offset(82.7, 84.0),
    Offset(84.0, 82.3),
    Offset(85.7, 80.7),
    Offset(87.0, 78.7),
    Offset(88.0, 77.3),
    Offset(88.7, 76.7),
    Offset(89.3, 75.7),
    Offset(90.7, 74.3),
    Offset(91.7, 73.3),
    Offset(92.3, 72.7),
    Offset(94.0, 71.0),
    Offset(95.7, 69.3),
    Offset(96.7, 68.3),
    Offset(97.3, 67.3),
    Offset(98.0, 66.7),
    Offset(98.3, 66.7),
    Offset(98.7, 66.0),
    Offset(99.0, 65.7),
    Offset(99.7, 65.0),
    Offset(100.3, 64.0),
    Offset(101.7, 63.3),
    Offset(102.0, 62.7),
    Offset(102.7, 62.0),
    Offset(103.3, 61.3),
    Offset(103.7, 61.0),
    Offset(104.3, 60.3),
    Offset(105.0, 59.7),
    Offset(105.7, 59.3),
    Offset(106.3, 58.7),
    Offset(107.0, 58.3),
    Offset(107.3, 57.7),
    Offset(107.7, 57.3),
    Offset(108.0, 57.3),
    Offset(108.7, 57.0),
    Offset(109.0, 56.7),
    Offset(109.3, 56.3),
    Offset(109.7, 56.0),
    Offset(110.3, 55.7),
    Offset(110.7, 55.3),
    Offset(111.3, 55.3),
    Offset(111.7, 55.0),
    Offset(112.0, 55.0),
    Offset(112.7, 54.7),
    Offset(113.3, 54.3),
    Offset(113.7, 54.3),
    Offset(114.0, 54.3),
    Offset(114.3, 54.3),
    Offset(114.7, 54.3),
    Offset(115.3, 54.3),
    Offset(115.7, 54.3),
    Offset(116.7, 54.3),
    Offset(117.3, 54.3),
    Offset(117.7, 54.3),
    Offset(118.0, 54.3),
    Offset(118.3, 54.3),
    Offset(119.0, 54.3),
    Offset(119.3, 54.7),
    Offset(120.0, 55.0),
    Offset(121.3, 55.3),
    Offset(122.3, 55.7),
    Offset(122.7, 56.0),
    Offset(123.7, 56.7),
    Offset(125.0, 58.0),
    Offset(125.7, 58.7),
    Offset(126.3, 59.0),
    Offset(127.0, 59.3),
    Offset(127.3, 60.0),
    Offset(128.0, 60.7),
    Offset(128.3, 61.0),
    Offset(128.3, 61.7),
    Offset(129.0, 62.3),
    Offset(129.7, 63.7),
    Offset(130.0, 64.3),
    Offset(130.0, 64.7),
    Offset(130.7, 65.7),
    Offset(130.7, 66.3),
    Offset(131.0, 67.0),
    Offset(131.3, 68.0),
    Offset(131.7, 68.7),
    Offset(132.0, 69.0),
    Offset(132.0, 69.7),
    Offset(132.3, 70.7),
    Offset(132.7, 71.0),
    Offset(133.0, 71.7),
    Offset(133.0, 72.3),
    Offset(133.3, 72.7),
    Offset(133.3, 73.7),
    Offset(133.7, 74.3),
    Offset(134.0, 75.3),
    Offset(134.3, 76.0),
    Offset(134.7, 77.0),
    Offset(135.0, 78.0),
    Offset(135.3, 78.7),
    Offset(135.7, 79.3),
    Offset(136.0, 80.3),
    Offset(136.3, 81.0),
    Offset(136.7, 81.7),
    Offset(137.0, 82.7),
    Offset(137.3, 84.0),
    Offset(137.3, 85.3),
    Offset(137.7, 87.0),
    Offset(138.3, 88.0),
    Offset(138.3, 88.7),
    Offset(138.7, 89.7),
    Offset(139.0, 90.3),
    Offset(139.3, 91.3),
    Offset(139.7, 92.7),
    Offset(140.0, 93.7),
    Offset(140.3, 94.0),
    Offset(140.7, 95.0),
    Offset(140.7, 95.3),
    Offset(140.7, 95.7),
    Offset(141.0, 96.3),
    Offset(141.3, 96.7),
    Offset(141.7, 97.3),
    Offset(142.0, 97.7),
    Offset(142.7, 98.3),
    Offset(142.7, 98.7),
    Offset(143.0, 99.0),
    Offset(143.3, 99.3),
    Offset(143.7, 99.7),
    Offset(144.0, 100.3),
    Offset(144.3, 100.3),
    Offset(144.3, 100.7),
    Offset(145.0, 101.0),
    Offset(145.3, 101.3),
    Offset(146.0, 101.7),
    Offset(146.3, 102.0),
    Offset(146.7, 102.3),
    Offset(147.0, 102.3),
    Offset(147.3, 102.3),
    Offset(147.7, 102.3),
    Offset(148.0, 102.7),
    Offset(148.3, 103.0),
    Offset(148.7, 103.0),
    Offset(149.3, 103.3),
    Offset(150.0, 103.3),
    Offset(150.3, 103.7),
    Offset(151.3, 103.7),
    Offset(152.0, 103.7),
    Offset(152.3, 103.7),
    Offset(153.0, 103.7),
    Offset(154.0, 103.7),
    Offset(155.3, 103.3),
    Offset(156.3, 103.3),
    Offset(157.0, 103.0),
    Offset(157.3, 102.7),
    Offset(158.0, 102.3),
    Offset(158.7, 102.0),
    Offset(159.0, 102.0),
    Offset(160.0, 101.0),
    Offset(160.7, 100.3),
    Offset(161.3, 99.3),
    Offset(161.7, 98.7),
    Offset(162.3, 98.0),
    Offset(162.7, 97.3),
    Offset(163.0, 97.0),
    Offset(163.3, 96.3),
    Offset(163.7, 95.3),
    Offset(164.3, 93.3),
    Offset(164.7, 91.7),
    Offset(164.7, 90.7),
    Offset(165.0, 89.3),
    Offset(165.3, 88.0),
    Offset(165.7, 87.3),
    Offset(165.7, 86.3),
    Offset(166.0, 85.0),
    Offset(166.3, 83.3),
    Offset(166.7, 81.0),
    Offset(167.0, 79.3),
    Offset(167.3, 78.7),
    Offset(167.3, 78.0),
    Offset(167.3, 77.0),
    Offset(167.3, 76.0),
    Offset(167.7, 75.7),
    Offset(167.7, 74.3),
    Offset(168.0, 73.3),
    Offset(168.0, 72.7),
    Offset(168.3, 71.3),
    Offset(168.7, 70.3),
    Offset(169.0, 69.0),
    Offset(169.0, 68.3),
    Offset(169.3, 68.0),
    Offset(169.3, 67.0),
    Offset(170.0, 64.7),
    Offset(170.7, 61.7),
    Offset(171.0, 61.0),
    Offset(171.7, 58.3),
    Offset(172.0, 57.7),
    Offset(172.0, 56.7),
    Offset(172.3, 55.7),
    Offset(172.3, 55.3),
    Offset(172.7, 54.0),
    Offset(172.7, 52.7),
    Offset(172.7, 51.3),
    Offset(172.7, 50.3),
    Offset(173.0, 48.7),
    Offset(173.3, 47.0),
    Offset(173.3, 45.7),
    Offset(173.3, 44.7),
    Offset(173.7, 44.0),
    Offset(173.7, 42.7),
    Offset(173.7, 41.7),
    Offset(173.7, 40.7),
    Offset(173.7, 39.7),
    Offset(173.7, 38.3),
    Offset(174.0, 36.3),
    Offset(174.0, 34.7),
    Offset(174.3, 33.7),
    Offset(174.3, 32.7),
    Offset(174.7, 32.0),
    Offset(174.7, 31.7),
    Offset(174.7, 30.7),
    Offset(174.7, 30.3),
    Offset(174.7, 29.7),
    Offset(174.7, 29.0),
    Offset(174.7, 28.7),
    Offset(174.7, 28.3),
    Offset(174.7, 28.0),
    Offset(175.0, 27.7),
    Offset(175.0, 27.0),
    Offset(175.0, 26.7),
    Offset(174.7, 27.0),
    Offset(174.0, 27.7),
    Offset(174.0, 28.0),
    Offset(172.7, 30.0),
    Offset(171.7, 31.0),
    Offset(170.3, 32.7),
    Offset(169.0, 34.3),
    Offset(168.0, 35.3),
    Offset(167.0, 36.3),
    Offset(165.7, 38.0),
    Offset(163.3, 40.3),
    Offset(162.3, 41.0),
    Offset(161.0, 42.3),
    Offset(157.3, 44.7),
    Offset(155.3, 47.0),
    Offset(153.0, 48.7),
    Offset(151.0, 50.0),
    Offset(148.7, 51.7),
    Offset(148.0, 52.7),
    Offset(147.0, 53.3),
    Offset(145.7, 54.3),
    Offset(144.3, 55.7),
    Offset(143.0, 57.0),
    Offset(141.3, 58.7),
    Offset(139.0, 60.7),
    Offset(137.0, 62.3),
    Offset(132.7, 65.7),
    Offset(131.3, 67.0),
    Offset(130.0, 67.7),
    Offset(129.0, 68.7),
    Offset(128.0, 69.7),
    Offset(127.3, 70.7),
    Offset(126.7, 70.7),
    Offset(125.3, 72.0),
    Offset(124.3, 73.0),
    Offset(123.3, 74.3),
    Offset(121.7, 75.0),
    Offset(120.3, 76.3),
    Offset(119.7, 77.3),
    Offset(119.0, 77.7),
    Offset(118.3, 78.3),
    Offset(118.0, 79.0),
    Offset(117.0, 80.0),
    Offset(116.3, 80.3),
    Offset(116.0, 80.3),
    Offset(116.0, 80.7),
    Offset(116.0, 81.0),
    Offset(116.3, 81.3),
    Offset(117.0, 81.3),
    Offset(117.7, 81.3),
    Offset(118.0, 81.7),
    Offset(119.3, 82.3),
    Offset(120.3, 82.3),
    Offset(121.3, 82.3),
    Offset(122.7, 82.3),
    Offset(124.7, 82.3),
    Offset(126.0, 82.3),
    Offset(127.3, 82.3),
    Offset(128.7, 82.3),
    Offset(130.7, 82.3),
    Offset(131.7, 82.3),
    Offset(133.0, 82.0),
    Offset(134.3, 81.7),
    Offset(134.7, 81.7),
    Offset(136.0, 81.7),
    Offset(137.7, 81.7),
    Offset(139.3, 81.3),
    Offset(140.3, 81.0),
    Offset(143.3, 80.3),
    Offset(145.3, 80.3),
    Offset(147.3, 80.0),
    Offset(149.3, 79.7),
    Offset(150.3, 79.7),
    Offset(153.0, 79.3),
    Offset(155.0, 79.0),
    Offset(156.3, 78.7),
    Offset(158.3, 78.3),
    Offset(159.3, 78.0),
    Offset(162.0, 77.7),
    Offset(163.3, 77.7),
    Offset(164.7, 77.3),
    Offset(166.0, 77.3),
    Offset(166.7, 77.0),
    Offset(169.3, 77.0),
    Offset(172.7, 76.3),
    Offset(174.7, 76.3),
    Offset(177.3, 75.7),
    Offset(178.7, 75.7),
    Offset(180.7, 75.7),
    Offset(184.0, 75.0),
    Offset(186.3, 74.7),
    Offset(188.3, 74.3),
    Offset(192.3, 74.0),
    Offset(194.7, 74.0),
    Offset(197.3, 73.7),
    Offset(199.7, 73.3),
    Offset(201.0, 73.0),
    Offset(201.7, 72.7),
    Offset(203.7, 72.3),
    Offset(207.0, 72.0),
    Offset(209.7, 71.7),
    Offset(212.3, 71.0),
    Offset(213.7, 70.7),
    Offset(214.7, 70.7),
    Offset(216.3, 70.7),
    Offset(217.7, 70.3),
    Offset(218.3, 70.0),
    Offset(219.3, 70.0),
    Offset(220.7, 69.7),
    Offset(222.3, 69.3),
    Offset(224.0, 69.0),
    Offset(225.3, 68.7),
    Offset(227.0, 68.3),
    Offset(229.3, 68.0),
    Offset(232.7, 67.7),
    Offset(235.3, 67.3),
    Offset(236.0, 67.3),
    Offset(236.3, 67.0),
    Offset(237.0, 67.0),
    Offset(237.7, 67.0),
    Offset(238.7, 66.7),
    Offset(240.3, 66.3),
    Offset(241.7, 66.0),
    Offset(243.0, 65.7),
    Offset(243.7, 65.7),
    Offset(245.0, 65.3),
    Offset(246.3, 65.0),
    Offset(247.3, 64.7),
    Offset(248.0, 64.3),
    Offset(249.0, 64.3),
    Offset(250.7, 64.0),
    Offset(251.7, 64.0),
    Offset(252.3, 63.7),
    Offset(253.3, 63.3),
    Offset(255.0, 63.0),
    Offset(256.0, 62.7),
    Offset(257.3, 62.7),
    Offset(258.0, 62.7),
    Offset(258.7, 62.3),
    Offset(260.7, 62.0),
    Offset(261.3, 61.7),
    Offset(262.0, 61.7),
    Offset(263.0, 61.3),
    Offset(264.0, 61.3),
    Offset(264.7, 61.3),
    Offset(265.3, 61.0),
    Offset(267.0, 61.0),
    Offset(267.7, 61.0),
    Offset(268.3, 61.0),
    Offset(269.0, 61.0),
    Offset(270.0, 61.0),
    Offset(271.0, 60.7),
    Offset(271.3, 60.7),
    Offset(272.0, 60.7),
    Offset(272.7, 60.7),
    Offset(273.3, 60.7),
    Offset(274.0, 60.7),
    Offset(274.3, 60.3),
    Offset(275.0, 60.3),
    Offset(275.7, 60.3),
    Offset(276.3, 60.3),
    Offset(277.0, 60.0),
    Offset(277.3, 60.0),
    Offset(277.7, 60.0),
    Offset(278.0, 59.7),
    Offset(278.3, 59.3),
    Offset(278.3, 59.7),
    Offset(278.0, 60.0),
    Offset(278.0, 60.7),
    Offset(277.3, 61.0),
    Offset(277.0, 61.3),
    Offset(276.7, 61.7),
    Offset(276.3, 62.0),
    Offset(275.7, 62.7),
    Offset(275.3, 63.0),
    Offset(275.0, 63.3),
    Offset(274.7, 63.7),
    Offset(274.3, 64.0),
    Offset(273.7, 64.7),
    Offset(273.0, 65.3),
    Offset(272.7, 66.0),
    Offset(272.3, 66.7),
    Offset(272.0, 67.0),
    Offset(271.7, 68.0),
    Offset(271.3, 68.7),
    Offset(271.3, 69.0),
    Offset(271.0, 69.0),
    Offset(270.7, 70.0),
    Offset(270.3, 70.7),
    Offset(270.0, 71.3),
    Offset(269.7, 72.3),
    Offset(269.3, 73.0),
    Offset(269.0, 73.3),
    Offset(269.0, 73.7),
    Offset(268.7, 74.0),
    Offset(268.7, 74.3),
    Offset(268.3, 75.0),
    Offset(268.3, 75.3),
    Offset(268.0, 75.7),
    Offset(268.0, 76.3),
    Offset(268.0, 76.7),
    Offset(267.7, 77.0),
    Offset(267.3, 77.7),
    Offset(267.0, 78.3),
    Offset(267.0, 79.0),
    Offset(266.3, 80.0),
    Offset(266.3, 81.0),
    Offset(266.0, 81.3),
    Offset(266.0, 82.0),
    Offset(266.0, 82.3),
    Offset(266.0, 83.0),
    Offset(266.0, 83.3),
    Offset(266.0, 83.7),
    Offset(266.0, 84.0),
    Offset(266.0, 84.3),
    Offset(266.0, 84.7),
    Offset(266.0, 85.3),
    Offset(266.0, 85.7),
    Offset(266.0, 86.3),
    Offset(266.0, 86.7),
    Offset(266.0, 87.0),
    Offset(266.0, 87.7),
    Offset(266.0, 88.0)
  ];

  testGoldens('SignatureBlock should be displayed correctly with signature',
      (tester) async {
    final testWidget = Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          SignatureBlock(
              points: signature,
              clearCanvas: () {},
              updateParentScrollState: (_) {},
              addPointToList: (_) {})
        ]));

    await TestUtil.testWidgetInBothThemes(
        tester: tester, testWidget: testWidget, widgetId: 'signature_block');
  });
}