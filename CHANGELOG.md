# Changelog

## [v1.1.0] 2025-07-21

- **Performance Optimization**: Refactored the `product/4` function in `AKSPrimalityTest` module to use tuples instead of maps for better performance
  - Replaced map-based coefficient storage with tuple-based storage
  - Simplified the result processing by using `put_elem/3` and `elem/2` operations
  - Removed unnecessary map-to-list conversion and sorting operations
  - Updated version from 1.0.0 to 1.1.0 in mix.exs

## [v1.0.0] 2025-07-21

- **Initial Release**: Complete implementation of the AKS (Agrawal-Kayal-Saxena) primality test algorithm
  - **Core Algorithm**: Pure Elixir implementation of the deterministic polynomial-time primality test
  - **Perfect Power Detection**: Efficient detection of perfect powers using the `PerfectPower` module
  - **GCD Calculations**: Fast GCD computations using the `LehmerGcd` module  
  - **Prime Factorization**: Support for prime factorization using the `PrimeFactorization` module
  - **Type Safety**: Full type specifications for all functions with `@spec` annotations
  - **Comprehensive Documentation**: Detailed mathematical documentation with KaTeX math rendering
  - **Mathematical Foundation**: Implementation based on the original AKS paper with proper polynomial arithmetic
  - **Deterministic Results**: Always provides correct answers (no probabilistic uncertainty)
  - **Polynomial Time Complexity**: Runs in O((log n)¹²) time
  - **Well-Tested**: Comprehensive test suite covering various edge cases and known primes/composites
