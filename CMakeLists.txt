cmake_minimum_required(VERSION 3.27)
project(aoc VERSION 2023 LANGUAGES Swift)

add_library(Util Util.swift)

link_libraries(Util)

add_executable(day1 day1.swift)
add_executable(day2 day2.swift)
add_executable(day3 day3.swift)
add_executable(day4 day4.swift)
add_executable(day5 day5.swift)
add_executable(day6 day6.swift)
add_executable(day7 day7.swift)
add_executable(day8 day8.swift)
add_executable(day9 day9.swift)


