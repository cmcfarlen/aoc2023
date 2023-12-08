cmake_minimum_required(VERSION 3.27)
project(aoc VERSION 2023 LANGUAGES Swift)

add_library(Util Util.swift)

link_libraries(Util)

add_executable(day1 day1.swift)
add_executable(day2 day2.swift)
add_executable(day3 day3.swift)
add_executable(day4 day4.swift)


