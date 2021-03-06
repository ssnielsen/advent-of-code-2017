//
//  Day20.swift
//  advent-of-code-2017
//
//  Created by Søren Nielsen on 24/12/2017.
//  Copyright © 2017 sonderby Inc. All rights reserved.
//

import Foundation

struct Day20: Day {
    typealias Coordinate = (x: Int, y: Int, z: Int)
    typealias Particle = (position: Coordinate, velocity: Coordinate, acceleration: Coordinate)

    static func part1(input: String) -> String {
        let particles = parse(input)

        let result = (0...1_000).reduce((particles: particles, closest: [Int]())) { result, _ in
            let particles = simulateTick(in: result.particles)
            let closest = result.closest + [closestParticle(in: particles)]
            return (particles, closest)
        }

        return "\(result.closest.last!)"
    }

    static func part2(input: String) -> String {
        let particles = parse(input)

        let result = collisionLoop(overParticles: particles, initialSize: particles.count)

        return "\(result.count)"
    }

    private static func simulateTick(in particles: [Particle]) -> [Particle] {
        return particles.map {
            let nextVelocity = $0.velocity + $0.acceleration
            return ($0.position + nextVelocity, nextVelocity, $0.acceleration)
        }
    }

    private static func collisionLoop(overParticles particles: [Particle], initialSize: Int) -> [Particle] {
        let particlesAfterTick = simulateTick(in: particles)
        let afterRemovingCollisions = removeCollisions(in: particlesAfterTick)

        if particlesAfterTick.count != initialSize && particlesAfterTick.count == afterRemovingCollisions.count {
            return afterRemovingCollisions
        } else {
            return collisionLoop(overParticles: afterRemovingCollisions, initialSize: initialSize)
        }
    }

    private static func closestParticle(in particles: [Particle]) -> Int {
        return particles.enumerated()
            .map { ($0.offset, $0.element.position) }
            .sorted { distanceToOrigin($0.1) < distanceToOrigin($1.1) }
            .first!.0
    }

    private static func removeCollisions(in particles: [Particle]) -> [Particle] {
        let range = 0..<particles.count
        let indexPairs: [(Int, Int)] = range.map { first in
            range.map { second in
                (first, second)
            }
        }.flatMap { $0 }
        let collidingParticles = indexPairs.reduce(Set<Int>()) { result, indexPair in
            let first = indexPair.0
            let second = indexPair.1
            if first != second && particles[first].position == particles[second].position {
                return result.union([first, second])
            } else {
                return result
            }
        }

        return particles.enumerated().filter { !collidingParticles.contains($0.offset) }.map { $0.element }
    }

    private static func distanceToOrigin(_ particle: Particle) -> Int {
        return distanceToOrigin(particle.position)
    }

    private static func distanceToOrigin(_ coordinate: Coordinate) -> Int {
        return abs(coordinate.x) + abs(coordinate.y) + abs(coordinate.z)
    }

    private static func parse(_ input: String) -> [Particle] {
        let parseCoordinate = { (s: String) -> Coordinate in
            let trimmed: Substring = s.dropFirst(3).dropLast(1)
            let splitted = trimmed.components(separatedBy: ",")
            return (Int(splitted[0])!, Int(splitted[1])!, Int(splitted[2])!)
        }

        return input.nonEmptyLines().map {
            let particle = $0.components(separatedBy: ", ")
            let position = parseCoordinate(particle[0])
            let velocity = parseCoordinate(particle[1])
            let acceleration = parseCoordinate(particle[2])
            return (position, velocity, acceleration)
        }
    }
}

func + (lhs: Day20.Coordinate, rhs: Day20.Coordinate) -> Day20.Coordinate {
    return (lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
}

func == (lhs: Day20.Coordinate, rhs: Day20.Coordinate) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}
