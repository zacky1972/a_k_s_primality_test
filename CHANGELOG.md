# Changelog

## [v1.1.1] 2025-07-22

- **Code Refactoring**: Improved code organization and readability in the `AKSPrimalityTest` module
  - Extracted complex logic from the main `of/1` function into three helper functions: `step1/1`, `step2/1`, and `step3/1`
  - Separated concerns: perfect power test, order finding, and GCD verification into distinct functions
  - Improved code maintainability while preserving the same algorithmic behavior
  - Enhanced readability by flattening nested logic and improving control flow
  - Updated version from 1.1.0 to 1.1.1 in mix.exs

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
